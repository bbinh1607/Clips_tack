import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipboardCard extends StatefulWidget {
  const ClipboardCard({
    required this.item,
    required this.relativeTime,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final ClipboardItem item;
  final String relativeTime;
  final ValueChanged<Rect?> onTap;
  final VoidCallback onLongPress;

  @override
  State<ClipboardCard> createState() => _ClipboardCardState();
}

class _ClipboardCardState extends State<ClipboardCard> {
  final _cardKey = GlobalKey();

  Rect? _globalBounds() {
    final renderObject = _cardKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }

    final offset = renderObject.localToGlobal(Offset.zero);
    return offset & renderObject.size;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.strongOutline,
    )!;
    final surfaceTint = Color.lerp(
      context.colors.surface,
      context.colors.primary,
      widget.item.isPinned
          ? AppOpacity.tintedSurface
          : AppOpacity.subtleSurface,
    )!;
    final kindIcon = switch (widget.item.kind) {
      ClipKind.link => Icons.link_rounded,
      ClipKind.phone => Icons.phone_rounded,
      ClipKind.text => null,
    };
    final contentStyle = context.text.bodyLarge?.copyWith(
      height: AppTypography.contentLineHeight,
      color: widget.item.kind == ClipKind.link
          ? context.colors.primary
          : context.colors.onSurface,
      fontWeight: FontWeight.w500,
      decoration: widget.item.kind == ClipKind.link
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: context.colors.primary,
    );
    final chips = <Widget>[
      if (widget.item.kind == ClipKind.link)
        _MetaChip(label: context.l10n.linkChip),
      if (widget.item.kind == ClipKind.phone)
        _MetaChip(label: context.l10n.phoneChip),
      if (widget.item.isPinned)
        _MetaChip(label: context.l10n.pinnedChip, icon: Icons.push_pin_rounded),
    ];

    return Material(
      key: _cardKey,
      color: surfaceTint,
      borderRadius: AppRadius.large,
      child: InkWell(
        onTap: () => widget.onTap(_globalBounds()),
        onLongPress: widget.onLongPress,
        borderRadius: AppRadius.large,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.large,
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: AppInsets.panel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText.bodySmall(
                        widget.relativeTime,
                        fontWeight: FontWeight.w600,
                        letterSpacing: AppTypography.timestampLetterSpacing,
                        color: Color.lerp(
                          context.colors.onSurface,
                          context.colors.surface,
                          AppOpacity.mutedText,
                        ),
                      ),
                    ),
                    if (kindIcon != null) ...[
                      Icon(
                        kindIcon,
                        size: AppSize.iconMedium,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: AppSpace.md),
                    ],
                    if (widget.item.isPinned)
                      Icon(
                        Icons.push_pin_rounded,
                        size: AppSize.iconMedium,
                        color: context.colors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpace.lg),
                Text(
                  widget.item.preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: contentStyle,
                ),
                if (chips.isNotEmpty) ...[
                  const SizedBox(height: AppSpace.xl),
                  Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.md,
                    children: chips,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

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
          if (icon != null) ...[
            Icon(icon, size: AppSize.iconSmall, color: context.colors.primary),
            const SizedBox(width: AppSpace.sm),
          ],
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
