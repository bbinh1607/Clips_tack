import 'package:flutter/material.dart';

class AppColors {
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0F8F83);

  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: brandBlue,
    secondary: accentTeal,
    brightness: Brightness.light,
    surface: const Color(0xFFF3F7FC),
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: brandBlue,
    secondary: accentTeal,
    brightness: Brightness.dark,
    surface: const Color(0xFF0E1626),
  );
}
