import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  static ThemeData light() {
    return _buildTheme(AppColors.light);
  }

  static ThemeData dark() {
    return _buildTheme(AppColors.dark);
  }

  static ThemeData _buildTheme(ColorScheme colors) {
    final inputFill = Color.lerp(
      colors.surface,
      colors.primary,
      colors.brightness == Brightness.dark
          ? AppOpacity.inputFillDark
          : AppOpacity.inputFillLight,
    )!;
    final borderColor = Color.lerp(
      colors.outline,
      colors.surface,
      AppOpacity.softOutline,
    )!;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      fontFamily: 'Roboto',
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextTheme.textTheme.titleLarge?.copyWith(
          color: colors.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: Color.lerp(
            colors.onSurface,
            colors.surface,
            AppOpacity.mediumOutline,
          ),
        ),
        contentPadding: AppInsets.inputContent,
        border: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(
            color: colors.primary,
            width: AppStroke.regular,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSize.primaryButtonHeight),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSize.primaryButtonHeight),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppSize.primaryButtonHeight),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppSize.iconButton, AppSize.iconButton),
          padding: AppInsets.iconButton,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTextTheme.textTheme.labelLarge?.copyWith(
            color: selected ? colors.primary : colors.onSurface,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color.lerp(
          colors.inverseSurface,
          colors.primary,
          AppOpacity.snackBlend,
        ),
        contentTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colors.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
    );
  }
}
