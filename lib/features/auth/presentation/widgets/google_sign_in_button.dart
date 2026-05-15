import 'package:clips_tack/core/assets/app_svg.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(0, AppSize.primaryButtonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpace.xxl),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppSvgImage(
            asset: AppSvg.iconGoogle,
            width: AppSize.iconMedium,
            height: AppSize.iconMedium,
          ),
          const SizedBox(width: AppSpace.lg),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
