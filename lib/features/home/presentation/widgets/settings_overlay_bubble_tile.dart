import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/home/presentation/controllers/overlay_bubble_controller.dart';
import 'package:flutter/material.dart';

class SettingsOverlayBubbleTile extends StatelessWidget {
  const SettingsOverlayBubbleTile({
    required this.state,
    required this.onChanged,
    super.key,
  });

  final OverlayBubbleSettingsState state;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = !state.hasPermission
        ? l10n.overlayBubblePermissionSubtitle
        : state.isRunning
        ? l10n.overlayBubbleSubtitleOn
        : l10n.overlayBubbleSubtitleOff;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: AppSize.iconContainer,
        width: AppSize.iconContainer,
        decoration: BoxDecoration(
          color: Color.lerp(
            context.colors.surface,
            context.colors.primary,
            AppOpacity.tintedSurface,
          ),
          borderRadius: AppRadius.small,
        ),
        child: Icon(Icons.bubble_chart_rounded, color: context.colors.primary),
      ),
      title: AppText.titleMedium(l10n.overlayBubbleTitle),
      subtitle: AppText.bodySmall(subtitle),
      trailing: Switch.adaptive(
        value: state.shouldShowBubble && state.hasPermission && state.isRunning,
        onChanged: state.isBusy ? null : onChanged,
      ),
    );
  }
}
