import 'dart:async';

import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/platform/mobile_shortcut_channel.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_detail_payload.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_editor_payload.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clipboard_action_sheet.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clipboard_list_content.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clipboard_list_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ClipboardListMode { history, starred }

const String _searchHistoryPrefsKey = 'clip_stack_search_history';
const int _maxSearchHistoryItems = 8;

class ClipboardListScreen extends StatefulWidget {
  const ClipboardListScreen({required this.mode, super.key});

  final ClipboardListMode mode;

  @override
  State<ClipboardListScreen> createState() => _ClipboardListScreenState();
}

class _ClipboardListScreenState extends State<ClipboardListScreen> {
  late final SearchController _searchController;
  Timer? _clockTimer;
  DateTime _now = DateTime.now();
  List<String> _searchHistory = const [];

  bool get _pinnedOnly => widget.mode == ClipboardListMode.starred;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController()
      ..text = context.read<ClipboardBloc>().state.searchQuery
      ..addListener(_onSearchChanged);
    MobileShortcutChannel.searchFocusRequests.addListener(
      _handleExternalSearchFocusRequest,
    );
    _loadSearchHistory();

    _clockTimer = Timer.periodic(AppDuration.relativeTimeTicker, (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    MobileShortcutChannel.searchFocusRequests.removeListener(
      _handleExternalSearchFocusRequest,
    );
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ClipboardBloc>().setSearchQuery(_searchController.text);
  }

  Future<void> _openSearchView() {
    final state = context.read<ClipboardBloc>().state;
    final source = _pinnedOnly ? state.pinnedItems : state.items;
    _searchController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _searchController.text.length,
    );

    return showClipboardSearch(
      context: context,
      searchController: _searchController,
      source: source,
      now: _now,
      searchHistory: _searchHistory,
      onSubmitSearch: _recordSearch,
      onRemoveSearchHistory: _removeSearchHistory,
      onOpenItem: _openItem,
    );
  }

  void _handleExternalSearchFocusRequest() {
    if (_pinnedOnly) {
      return;
    }

    _openSearchView();
  }

  void _clearSearchOrUnfocus() {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      return;
    }

    context.hideKeyboard();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }

    setState(() {
      _searchHistory =
          prefs.getStringList(_searchHistoryPrefsKey) ?? const <String>[];
    });
  }

  Future<void> _recordSearch(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return;
    }

    final nextHistory = [
      normalized,
      ..._searchHistory.where(
        (entry) => entry.toLowerCase() != normalized.toLowerCase(),
      ),
    ].take(_maxSearchHistoryItems).toList(growable: false);

    setState(() {
      _searchHistory = nextHistory;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryPrefsKey, nextHistory);
  }

  Future<void> _removeSearchHistory(String query) async {
    final nextHistory = _searchHistory
        .where((entry) => entry != query)
        .toList(growable: false);

    setState(() {
      _searchHistory = nextHistory;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryPrefsKey, nextHistory);
  }

  Future<void> _copyItem(ClipboardItem item) async {
    await context.read<ClipboardBloc>().copyClip(item);
    if (!mounted) {
      return;
    }

    _showSnackBar(context.l10n.copiedMessage);
  }

  void _togglePin(ClipboardItem item) {
    context.read<ClipboardBloc>().togglePin(item.id);
    _showSnackBar(
      item.isPinned ? context.l10n.unpinnedMessage : context.l10n.pinnedMessage,
    );
  }

  Future<void> _openItem(ClipboardItem item, Rect? sourceRect) async {
    context.hideKeyboard();

    final message = await context.pushNamed<String>(
      AppRoutes.clipDetail,
      extra: ClipDetailPayload(
        item: item,
        sourceRect: sourceRect,
        items: context.read<ClipboardBloc>().state.visibleItems(
          pinnedOnly: _pinnedOnly,
        ),
      ),
    );

    if (!mounted || message == null) {
      return;
    }

    _showSnackBar(message);
  }

  Future<void> _showItemActions(ClipboardItem item) async {
    final action = await showClipboardItemActions(context: context, item: item);

    if (!mounted || action == null) {
      return;
    }

    final bloc = context.read<ClipboardBloc>();

    switch (action) {
      case ClipboardItemAction.copy:
        await _copyItem(item);
      case ClipboardItemAction.pin:
        _togglePin(item);
      case ClipboardItemAction.delete:
        bloc.deleteClip(item.id);
        _showSnackBar(context.l10n.deletedMessage);
      case ClipboardItemAction.edit:
        final message = await context.pushNamed<String>(
          AppRoutes.editor,
          extra: ClipEditorPayload(
            clipId: item.id,
            initialContent: item.content,
          ),
        );

        if (!context.mounted || message == null) {
          return;
        }

        _showSnackBar(message);
    }
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: AppText.bodyMedium(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyF, control: true):
              _openSearchView,
          const SingleActivator(LogicalKeyboardKey.keyF, meta: true):
              _openSearchView,
          const SingleActivator(LogicalKeyboardKey.escape):
              _clearSearchOrUnfocus,
        },
        child: BlocListener<ClipboardBloc, ClipboardState>(
          listenWhen: (previous, current) =>
              previous.searchQuery != current.searchQuery &&
              current.searchQuery != _searchController.text,
          listener: (context, state) {
            _searchController.value = TextEditingValue(
              text: state.searchQuery,
              selection: TextSelection.collapsed(
                offset: state.searchQuery.length,
              ),
            );
          },
          child: BlocBuilder<ClipboardBloc, ClipboardState>(
            builder: (context, state) {
              final l10n = context.l10n;
              final source = _pinnedOnly ? state.pinnedItems : state.items;
              final visibleItems = state.visibleItems(pinnedOnly: _pinnedOnly);
              final label = _pinnedOnly
                  ? l10n.pinnedSnippetsTitle
                  : l10n.recentSnippetsTitle;
              final helper = _pinnedOnly
                  ? l10n.pinnedSnippetsHelper
                  : l10n.recentSnippetsHelper;

              return Column(
                children: [
                  ClipboardListHeader(
                    searchController: _searchController,
                    hasSearchQuery: state.hasSearchQuery,
                    title: label,
                    helper: helper,
                    countLabel: l10n.itemCount(visibleItems.length),
                    onOpenSearch: _openSearchView,
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: AppDuration.short,
                      child: ClipboardListContent(
                        modeName: widget.mode.name,
                        pinnedOnly: _pinnedOnly,
                        allItemsEmpty: state.items.isEmpty,
                        source: source,
                        visibleItems: visibleItems,
                        hasSearchQuery: state.hasSearchQuery,
                        now: _now,
                        onOpenItem: _openItem,
                        onShowItemActions: _showItemActions,
                        onCopyItem: _copyItem,
                        onTogglePin: _togglePin,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
