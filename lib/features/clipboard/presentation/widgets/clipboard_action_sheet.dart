import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:flutter/material.dart';

enum ClipboardItemAction { copy, pin, delete, edit }

Future<ClipboardItemAction?> showClipboardItemActions({
  required BuildContext context,
  required ClipboardItem item,
}) {
  return showModalBottomSheet<ClipboardItemAction>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;

      return SafeArea(
        child: Padding(
          padding: AppInsets.sheet,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionTile(
                icon: Icons.copy_rounded,
                label: l10n.copyAction,
                onTap: () =>
                    Navigator.of(sheetContext).pop(ClipboardItemAction.copy),
              ),
              _ActionTile(
                icon: item.isPinned
                    ? Icons.push_pin_outlined
                    : Icons.push_pin_rounded,
                label: item.isPinned ? l10n.unpinAction : l10n.pinAction,
                onTap: () =>
                    Navigator.of(sheetContext).pop(ClipboardItemAction.pin),
              ),
              _ActionTile(
                icon: Icons.edit_rounded,
                label: l10n.editAction,
                onTap: () =>
                    Navigator.of(sheetContext).pop(ClipboardItemAction.edit),
              ),
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                label: l10n.deleteAction,
                destructive: true,
                onTap: () =>
                    Navigator.of(sheetContext).pop(ClipboardItemAction.delete),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? context.colors.error : context.colors.onSurface;

    return ListTile(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      leading: Icon(icon, color: color),
      title: AppText.bodyLarge(label, color: color),
      onTap: onTap,
    );
  }
}
