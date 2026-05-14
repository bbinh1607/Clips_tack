import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SettingsStatsTile extends StatelessWidget {
  const SettingsStatsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
          child: Icon(icon, color: context.colors.primary),
        ),
        const SizedBox(width: AppSpace.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMedium(title),
              const SizedBox(height: AppSpace.xxs),
              AppText.bodySmall(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
