import 'package:clips_tack/core/assets/app_svg.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class LoginIcon extends StatelessWidget {
  final String icon;
  const LoginIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.iconLarge,
      height: AppSize.iconLarge,
      child: AppSvgImage(asset: icon),
    );
  }
}
