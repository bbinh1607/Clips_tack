import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/utils/relative_time_formatter.dart';
import 'package:flutter/material.dart';

Future<void> showClipboardSearch({
  required BuildContext context,
  required SearchController searchController,
  required List<ClipboardItem> source,
  required DateTime now,
  required List<String> searchHistory,
  required ValueChanged<String> onSubmitSearch,
  required ValueChanged<String> onRemoveSearchHistory,
  required Future<void> Function(ClipboardItem item, Rect? sourceRect)
  onOpenItem,
}) {
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: true,
      transitionDuration: AppDuration.clipExpand,
      reverseTransitionDuration: AppDuration.clipCollapse,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ClipboardSearchScreen(
          searchController: searchController,
          source: source,
          now: now,
          searchHistory: searchHistory,
          onSubmitSearch: onSubmitSearch,
          onRemoveSearchHistory: onRemoveSearchHistory,
          onOpenItem: onOpenItem,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.035),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}

class ClipboardListHeader extends StatelessWidget {
  const ClipboardListHeader({
    required this.searchController,
    required this.hasSearchQuery,
    required this.title,
    required this.helper,
    required this.countLabel,
    required this.onOpenSearch,
    super.key,
  });

  final SearchController searchController;
  final bool hasSearchQuery;
  final String title;
  final String helper;
  final String countLabel;
  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchFill = Color.lerp(
      context.colors.surface,
      context.colors.primary,
      context.isDark ? AppOpacity.inputFillDark : AppOpacity.inputFillLight,
    )!;
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.softOutline,
    )!;

    return Padding(
      padding: AppInsets.sectionHeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            controller: searchController,
            hintText: l10n.searchClipboardPlaceholder,
            leading: const Icon(Icons.search_rounded),
            trailing: hasSearchQuery
                ? [
                    IconButton(
                      tooltip: l10n.clearSearchTooltip,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: searchController.clear,
                    ),
                  ]
                : null,
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(searchFill),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            side: WidgetStatePropertyAll(BorderSide(color: borderColor)),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: AppRadius.field),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: AppSpace.xxl),
            ),
            readOnly: true,
            onTap: onOpenSearch,
            textInputAction: TextInputAction.search,
          ),
          if (hasSearchQuery) ...[
            const SizedBox(height: AppSpace.lg),
            _ActiveSearchPill(
              query: searchController.text,
              onClear: searchController.clear,
            ),
          ],
          const SizedBox(height: AppSpace.xxxl),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleMedium(title),
                    const SizedBox(height: AppSpace.xs),
                    AppText.bodySmall(
                      helper,
                      color: Color.lerp(
                        context.colors.onSurface,
                        context.colors.surface,
                        AppOpacity.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              _CountBadge(label: countLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClipboardSearchScreen extends StatefulWidget {
  const _ClipboardSearchScreen({
    required this.searchController,
    required this.source,
    required this.now,
    required this.searchHistory,
    required this.onSubmitSearch,
    required this.onRemoveSearchHistory,
    required this.onOpenItem,
  });

  final SearchController searchController;
  final List<ClipboardItem> source;
  final DateTime now;
  final List<String> searchHistory;
  final ValueChanged<String> onSubmitSearch;
  final ValueChanged<String> onRemoveSearchHistory;
  final Future<void> Function(ClipboardItem item, Rect? sourceRect) onOpenItem;

  @override
  State<_ClipboardSearchScreen> createState() => _ClipboardSearchScreenState();
}

class _ClipboardSearchScreenState extends State<_ClipboardSearchScreen> {
  late final FocusNode _focusNode;
  late List<String> _searchHistory;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchHistory = widget.searchHistory.toList(growable: true);
    widget.searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _close() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _selectHistory(String query) {
    widget.searchController.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
  }

  void _removeHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
    widget.onRemoveSearchHistory(query);
  }

  void _recordSearch(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return;
    }

    setState(() {
      _searchHistory
        ..removeWhere(
          (entry) => entry.toLowerCase() == normalized.toLowerCase(),
        )
        ..insert(0, normalized);
    });
    widget.onSubmitSearch(normalized);
  }

  void _openItem(ClipboardItem item) {
    _recordSearch(widget.searchController.text);
    _close();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOpenItem(item, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = widget.searchController.text.trim();
    final searchFill = Color.lerp(
      context.colors.surface,
      context.colors.primary,
      context.isDark ? AppOpacity.inputFillDark : AppOpacity.inputFillLight,
    )!;
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.softOutline,
    )!;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.lg,
                AppSpace.md,
                AppSpace.lg,
                AppSpace.lg,
              ),
              child: SearchBar(
                controller: widget.searchController,
                focusNode: _focusNode,
                autoFocus: true,
                hintText: l10n.searchClipboardPlaceholder,
                leading: IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _close,
                ),
                trailing: widget.searchController.text.isEmpty
                    ? null
                    : [
                        IconButton(
                          tooltip: l10n.clearSearchTooltip,
                          icon: const Icon(Icons.close_rounded),
                          onPressed: widget.searchController.clear,
                        ),
                      ],
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(searchFill),
                surfaceTintColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                side: WidgetStatePropertyAll(BorderSide(color: borderColor)),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: AppRadius.field),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.only(right: AppSpace.xxl),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  _recordSearch(value);
                  context.hideKeyboard();
                },
              ),
            ),
            Expanded(
              child: _SearchBody(
                query: query,
                source: widget.source,
                now: widget.now,
                searchHistory: _searchHistory,
                onSelectHistory: _selectHistory,
                onRemoveHistory: _removeHistory,
                onOpenItem: _openItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({
    required this.query,
    required this.source,
    required this.now,
    required this.searchHistory,
    required this.onSelectHistory,
    required this.onRemoveHistory,
    required this.onOpenItem,
  });

  final String query;
  final List<ClipboardItem> source;
  final DateTime now;
  final List<String> searchHistory;
  final ValueChanged<String> onSelectHistory;
  final ValueChanged<String> onRemoveHistory;
  final ValueChanged<ClipboardItem> onOpenItem;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      if (searchHistory.isEmpty) {
        return _SearchEmptyResult(message: _emptySearchHistoryMessage(context));
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screen,
          AppSpace.md,
          AppSpace.screen,
          AppSpace.pageBottom,
        ),
        children: [
          for (final historyQuery in searchHistory)
            _SearchHistoryTile(
              query: historyQuery,
              onTap: () => onSelectHistory(historyQuery),
              onRemove: () => onRemoveHistory(historyQuery),
            ),
        ],
      );
    }

    final results = source
        .where((item) => item.matchesQuery(query))
        .toList(growable: false);

    if (results.isEmpty) {
      return _SearchEmptyResult(message: context.l10n.noSearchResultsMessage);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.screen,
        AppSpace.md,
        AppSpace.screen,
        AppSpace.pageBottom,
      ),
      children: [
        for (final item in results)
          _SearchResultTile(
            item: item,
            relativeTime: formatRelativeTime(context, item.createdAt, now),
            onTap: () => onOpenItem(item),
          ),
      ],
    );
  }

  String _emptySearchHistoryMessage(BuildContext context) {
    return context.locale.languageCode == 'vi'
        ? 'Chưa có tìm kiếm gần đây.'
        : 'No recent searches yet.';
  }
}

class _SearchHistoryTile extends StatelessWidget {
  const _SearchHistoryTile({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.strongOutline,
    )!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.md,
              vertical: AppSpace.lg,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: Color.lerp(
                    context.colors.onSurface,
                    context.colors.surface,
                    AppOpacity.mutedText,
                  ),
                ),
                const SizedBox(width: AppSpace.xxl),
                Expanded(
                  child: AppText.bodyMedium(
                    query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.clearSearchTooltip,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.item,
    required this.relativeTime,
    required this.onTap,
  });

  final ClipboardItem item;
  final String relativeTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.strongOutline,
    )!;
    final contentStyle = context.text.bodyMedium?.copyWith(
      height: AppTypography.contentLineHeight,
      color: item.kind == ClipKind.link
          ? context.colors.primary
          : context.colors.onSurface,
      fontWeight: FontWeight.w500,
      decoration: item.kind == ClipKind.link
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: context.colors.primary,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Ink(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.md,
              vertical: AppSpace.xxl,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSize.iconContainer,
                  height: AppSize.iconContainer,
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      context.colors.surface,
                      context.colors.primary,
                      AppOpacity.tintedSurface,
                    ),
                    borderRadius: AppRadius.medium,
                  ),
                  child: Icon(
                    _iconFor(item.kind),
                    color: context.colors.primary,
                    size: AppSize.iconMedium,
                  ),
                ),
                const SizedBox(width: AppSpace.xxl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(
                        relativeTime,
                        fontWeight: FontWeight.w600,
                        letterSpacing: AppTypography.timestampLetterSpacing,
                        color: Color.lerp(
                          context.colors.onSurface,
                          context.colors.surface,
                          AppOpacity.mutedText,
                        ),
                      ),
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        item.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: contentStyle,
                      ),
                    ],
                  ),
                ),
                if (item.isPinned) ...[
                  const SizedBox(width: AppSpace.md),
                  Icon(
                    Icons.push_pin_rounded,
                    size: AppSize.iconMedium,
                    color: context.colors.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(ClipKind kind) {
    return switch (kind) {
      ClipKind.link => Icons.link_rounded,
      ClipKind.phone => Icons.phone_rounded,
      ClipKind.text => Icons.content_paste_search_rounded,
    };
  }
}

class _SearchEmptyResult extends StatelessWidget {
  const _SearchEmptyResult({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.emptyState),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: AppSize.emptyStateIcon,
            color: Color.lerp(
              context.colors.onSurface,
              context.colors.surface,
              AppOpacity.mutedText,
            ),
          ),
          const SizedBox(height: AppSpace.xxl),
          AppText.bodyMedium(
            message,
            textAlign: TextAlign.center,
            color: Color.lerp(
              context.colors.onSurface,
              context.colors.surface,
              AppOpacity.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveSearchPill extends StatelessWidget {
  const _ActiveSearchPill({required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpace.xxl,
        right: AppSpace.sm,
        top: AppSpace.sm,
        bottom: AppSpace.sm,
      ),
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.tintedSurface,
        ),
        borderRadius: AppRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppText.bodySmall(
              query,
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          IconButton(
            tooltip: context.l10n.clearSearchTooltip,
            icon: const Icon(Icons.close_rounded),
            iconSize: AppSize.iconSmall,
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            padding: EdgeInsets.zero,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.badge,
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.tintedSurface,
        ),
        borderRadius: AppRadius.pill,
      ),
      child: AppText.bodySmall(
        label,
        color: context.colors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
