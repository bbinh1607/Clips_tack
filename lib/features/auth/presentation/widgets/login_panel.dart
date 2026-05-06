import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.strongOutline,
    )!;
    final background = Color.lerp(
      context.colors.surface,
      context.colors.primary,
      context.isDark ? AppOpacity.softSurface : AppOpacity.subtleSurface,
    )!;

    return Container(
      padding: AppInsets.panel,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.large,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.18 : 0.06),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}