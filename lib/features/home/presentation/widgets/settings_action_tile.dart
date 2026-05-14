import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    final iconColor = isEnabled
        ? context.colors.error
        : Color.lerp(
            context.colors.onSurface,
            context.colors.surface,
            AppOpacity.mutedText,
          );

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: AppSize.iconContainer,
        width: AppSize.iconContainer,
        decoration: BoxDecoration(
          color: Color.lerp(
            context.colors.surface,
            context.colors.error,
            AppOpacity.tintedSurface,
          ),
          borderRadius: AppRadius.small,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: AppText.titleMedium(title, color: iconColor),
      subtitle: AppText.bodySmall(subtitle),
      trailing: Icon(Icons.chevron_right_rounded, color: iconColor),
    );
  }
}
