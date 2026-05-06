import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';

enum AppTextVariant {
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
}

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  });

  const AppText.titleLarge(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  }) : variant = AppTextVariant.titleLarge;

  const AppText.titleMedium(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  }) : variant = AppTextVariant.titleMedium;

  const AppText.bodyLarge(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  }) : variant = AppTextVariant.bodyLarge;

  const AppText.bodyMedium(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  }) : variant = AppTextVariant.bodyMedium;

  const AppText.bodySmall(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  }) : variant = AppTextVariant.bodySmall;

  const AppText.labelLarge(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
    this.letterSpacing,
    this.decoration,
  }) : variant = AppTextVariant.labelLarge;

  final String data;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final double? height;
  final double? letterSpacing;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _resolveStyle(context)
          .copyWith(
            color: color,
            fontWeight: fontWeight,
            height: height,
            letterSpacing: letterSpacing,
            decoration: decoration,
          )
          .merge(style),
    );
  }

  TextStyle _resolveStyle(BuildContext context) {
    return switch (variant) {
      AppTextVariant.titleLarge => context.text.titleLarge ?? const TextStyle(),
      AppTextVariant.titleMedium =>
        context.text.titleMedium ?? const TextStyle(),
      AppTextVariant.bodyLarge => context.text.bodyLarge ?? const TextStyle(),
      AppTextVariant.bodyMedium => context.text.bodyMedium ?? const TextStyle(),
      AppTextVariant.bodySmall => context.text.bodySmall ?? const TextStyle(),
      AppTextVariant.labelLarge => context.text.labelLarge ?? const TextStyle(),
    };
  }
}
