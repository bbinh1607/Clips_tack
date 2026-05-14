import 'dart:async';

import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/home/models/clip_detail_payload.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/widgets/clipboard_action_sheet.dart';
import 'package:clips_tack/features/home/presentation/widgets/clipboard_list_content.dart';
import 'package:clips_tack/features/home/presentation/widgets/clipboard_list_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum ClipboardListMode { history, starred }

class ClipboardListScreen extends StatefulWidget {
  const ClipboardListScreen({required this.mode, super.key});

  final ClipboardListMode mode;

  @override
  State<ClipboardListScreen> createState() => _ClipboardListScreenState();
}

class _ClipboardListScreenState extends State<ClipboardListScreen> {
  late final TextEditingController _searchController;
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  bool get _pinnedOnly => widget.mode == ClipboardListMode.starred;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<ClipboardBloc>().state.searchQuery,
    )..addListener(_onSearchChanged);

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
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ClipboardBloc>().setSearchQuery(_searchController.text);
  }

  Future<void> _copyItem(ClipboardItem item) async {
    await context.read<ClipboardBloc>().copyClip(item);
    if (!mounted) {
      return;
    }

    _showSnackBar(context.l10n.copiedMessage);
  }

  Future<void> _openItem(ClipboardItem item, Rect? sourceRect) async {
    context.hideKeyboard();

    final message = await context.pushNamed<String>(
      AppRoutes.clipDetail,
      extra: ClipDetailPayload(item: item, sourceRect: sourceRect),
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
        bloc.togglePin(item.id);
        _showSnackBar(
          item.isPinned
              ? context.l10n.unpinnedMessage
              : context.l10n.pinnedMessage,
        );
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
    return BlocListener<ClipboardBloc, ClipboardState>(
      listenWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery &&
          current.searchQuery != _searchController.text,
      listener: (context, state) {
        _searchController.value = TextEditingValue(
          text: state.searchQuery,
          selection: TextSelection.collapsed(offset: state.searchQuery.length),
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
