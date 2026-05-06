import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSvg {
  AppSvg._();

  static const String _base = 'assets/svg';

  static const String iconGoogle = '$_base/icon_google.svg';
}

class AppSvgImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final Color? color;

  const AppSvgImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
