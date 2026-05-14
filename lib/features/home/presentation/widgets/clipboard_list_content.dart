import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:clips_tack/features/home/presentation/utils/relative_time_formatter.dart';
import 'package:clips_tack/features/home/presentation/widgets/clipboard_card.dart';
import 'package:clips_tack/features/home/presentation/widgets/clipboard_empty_state.dart';
import 'package:flutter/material.dart';

class ClipboardListContent extends StatelessWidget {
  const ClipboardListContent({
    required this.modeName,
    required this.pinnedOnly,
    required this.allItemsEmpty,
    required this.source,
    required this.visibleItems,
    required this.hasSearchQuery,
    required this.now,
    required this.onOpenItem,
    required this.onShowItemActions,
    super.key,
  });

  final String modeName;
  final bool pinnedOnly;
  final bool allItemsEmpty;
  final List<ClipboardItem> source;
  final List<ClipboardItem> visibleItems;
  final bool hasSearchQuery;
  final DateTime now;
  final Future<void> Function(ClipboardItem item, Rect? sourceRect) onOpenItem;
  final Future<void> Function(ClipboardItem item) onShowItemActions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (allItemsEmpty) {
      return const Padding(
        key: ValueKey('empty-history'),
        padding: AppInsets.listWithFab,
        child: ClipboardEmptyHistory(),
      );
    }

    if (source.isEmpty && pinnedOnly) {
      return const ClipboardEmptyStarred(key: ValueKey('empty-starred'));
    }

    if (visibleItems.isEmpty) {
      final message = hasSearchQuery
          ? l10n.noSearchResultsMessage
          : l10n.pinClipPrompt;

      return ClipboardNoResults(
        key: const ValueKey('no-results'),
        message: message,
      );
    }

    return ListView.separated(
      key: ValueKey('list-$modeName'),
      padding: AppInsets.listWithFab,
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        return ClipboardCard(
          key: ValueKey('clipboard-card-$modeName-${item.id}'),
          item: item,
          relativeTime: formatRelativeTime(context, item.createdAt, now),
          onTap: (sourceRect) => onOpenItem(item, sourceRect),
          onLongPress: () => onShowItemActions(item),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppSpace.lg),
      itemCount: visibleItems.length,
    );
  }
}
