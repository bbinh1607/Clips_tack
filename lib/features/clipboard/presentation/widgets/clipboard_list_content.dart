import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/utils/relative_time_formatter.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clipboard_card.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clipboard_empty_state.dart';
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
    required this.onCopyItem,
    required this.onTogglePin,
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
  final Future<void> Function(ClipboardItem item) onCopyItem;
  final void Function(ClipboardItem item) onTogglePin;

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
        return Dismissible(
          key: ValueKey('clipboard-swipe-$modeName-${item.id}'),
          direction: DismissDirection.horizontal,
          dismissThresholds: const {
            DismissDirection.startToEnd: 0.32,
            DismissDirection.endToStart: 0.32,
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              await onCopyItem(item);
            } else {
              onTogglePin(item);
            }

            return false;
          },
          background: _SwipeActionBackground(
            icon: Icons.copy_rounded,
            label: l10n.copyAction,
            alignment: Alignment.centerLeft,
            color: context.colors.primary,
          ),
          secondaryBackground: _SwipeActionBackground(
            icon: item.isPinned
                ? Icons.push_pin_outlined
                : Icons.push_pin_rounded,
            label: item.isPinned ? l10n.unpinAction : l10n.pinAction,
            alignment: Alignment.centerRight,
            color: context.colors.secondary,
          ),
          child: ClipboardCard(
            item: item,
            relativeTime: formatRelativeTime(context, item.createdAt, now),
            onTap: (sourceRect) => onOpenItem(item, sourceRect),
            onLongPress: () => onShowItemActions(item),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppSpace.lg),
      itemCount: visibleItems.length,
    );
  }
}

class _SwipeActionBackground extends StatelessWidget {
  const _SwipeActionBackground({
    required this.icon,
    required this.label,
    required this.alignment,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.centerLeft;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.panel),
      decoration: BoxDecoration(color: color, borderRadius: AppRadius.large),
      child: Row(
        mainAxisAlignment: isLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (!isLeft) ...[
            AppText.labelLarge(
              label,
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(width: AppSpace.lg),
          ],
          Icon(icon, color: context.colors.onPrimary),
          if (isLeft) ...[
            const SizedBox(width: AppSpace.lg),
            AppText.labelLarge(
              label,
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ],
        ],
      ),
    );
  }
}
