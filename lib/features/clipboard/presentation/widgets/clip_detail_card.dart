import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/utils/relative_time_formatter.dart';
import 'package:flutter/material.dart';

class ClipDetailCard extends StatelessWidget {
  const ClipDetailCard({
    required this.item,
    required this.radius,
    required this.onCopy,
    required this.onTogglePin,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final ClipboardItem item;
  final double radius;
  final VoidCallback onCopy;
  final VoidCallback onTogglePin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final contentStyle = context.text.bodyLarge?.copyWith(
      height: 1.55,
      color: item.kind == ClipKind.link
          ? context.colors.primary
          : context.colors.onSurface,
      fontWeight: FontWeight.w500,
      decoration: item.kind == ClipKind.link
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: context.colors.primary,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.28 : 0.14),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: context.colors.surface,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xxl,
                  AppSpace.xxl,
                  AppSpace.xxl,
                  AppSpace.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: l10n.copyAction,
                      icon: const Icon(Icons.copy_rounded),
                      onPressed: onCopy,
                    ),
                    IconButton(
                      tooltip: item.isPinned
                          ? l10n.unpinAction
                          : l10n.pinAction,
                      icon: Icon(
                        item.isPinned
                            ? Icons.push_pin_outlined
                            : Icons.push_pin_rounded,
                      ),
                      onPressed: onTogglePin,
                    ),
                    IconButton(
                      tooltip: l10n.editAction,
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      tooltip: l10n.deleteAction,
                      color: context.colors.error,
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.screen,
                        AppSpace.lg,
                        AppSpace.screen,
                        AppSpace.section,
                      ),
                      sliver: SliverList.list(
                        children: [
                          Wrap(
                            spacing: AppSpace.md,
                            runSpacing: AppSpace.md,
                            children: [
                              _DetailChip(
                                icon: Icons.schedule_rounded,
                                label: formatRelativeTime(
                                  context,
                                  item.createdAt,
                                  DateTime.now(),
                                ),
                              ),
                              if (item.kind == ClipKind.link)
                                _DetailChip(
                                  icon: Icons.link_rounded,
                                  label: l10n.linkChip,
                                ),
                              if (item.kind == ClipKind.phone)
                                _DetailChip(
                                  icon: Icons.phone_rounded,
                                  label: l10n.phoneChip,
                                ),
                              if (item.isPinned)
                                _DetailChip(
                                  icon: Icons.push_pin_rounded,
                                  label: l10n.pinnedChip,
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpace.section),
                          SelectableText(item.content, style: contentStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.chip,
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
          Icon(icon, size: AppSize.iconSmall, color: context.colors.primary),
          const SizedBox(width: AppSpace.sm),
          AppText.bodySmall(
            label,
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
