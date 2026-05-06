import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class LoginBrand extends StatelessWidget {
  const LoginBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: context.colors.primary,
            borderRadius: AppRadius.large,
            boxShadow: [
              BoxShadow(
                color: context.colors.primary.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Icon(
            Icons.content_paste_go_rounded,
            size: 42,
            color: context.colors.onPrimary,
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        AppText.titleLarge(
          l10n.appName,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpace.xs),
        AppText.bodySmall(
          l10n.loginBrandTagline,
          color: Color.lerp(
            context.colors.onSurface,
            context.colors.surface,
            AppOpacity.mutedText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}