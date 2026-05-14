import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.panel,
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.softSurface,
        ),
        borderRadius: AppRadius.large,
        border: Border.all(
          color: Color.lerp(
            context.colors.outline,
            context.colors.surface,
            AppOpacity.mediumOutline,
          )!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.titleMedium(title),
          const SizedBox(height: AppSpace.lg),
          child,
        ],
      ),
    );
  }
}
