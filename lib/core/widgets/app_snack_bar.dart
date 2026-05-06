import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

enum AppSnackBarType { info, success, error }

class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: duration,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: _AppSnackBarContent(message: message, type: type),
        ),
      );
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({required this.message, required this.type});

  final String message;
  final AppSnackBarType type;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(context);
    final backgroundColor = Color.lerp(
      context.colors.inverseSurface,
      accentColor,
      context.isDark ? AppOpacity.tintedSurface : AppOpacity.snackBlend,
    )!;
    final foregroundColor = context.colors.onInverseSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.xxl,
        vertical: AppSpace.lg,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.24 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.iconContainer,
            height: AppSize.iconContainer,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.16),
              borderRadius: AppRadius.medium,
            ),
            child: Icon(
              _icon,
              color: foregroundColor,
              size: AppSize.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: AppText.bodyMedium(
              message,
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    return switch (type) {
      AppSnackBarType.info => Icons.info_outline_rounded,
      AppSnackBarType.success => Icons.check_circle_outline_rounded,
      AppSnackBarType.error => Icons.error_outline_rounded,
    };
  }

  Color _accentColor(BuildContext context) {
    return switch (type) {
      AppSnackBarType.info => context.colors.primary,
      AppSnackBarType.success => context.colors.secondary,
      AppSnackBarType.error => context.colors.error,
    };
  }
}
