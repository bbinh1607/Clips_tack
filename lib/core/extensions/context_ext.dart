import 'package:flutter/material.dart';
import 'package:clips_tack/share/l10n/generated/app_localizations.dart';

extension ContextExt on BuildContext {
  /// 🌗 Theme
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  bool get isLight => Theme.of(this).brightness == Brightness.light;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;

  /// 🌐 Localization
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  Locale get locale => Localizations.localeOf(this);

  /// 📱 Size
  Size get size => MediaQuery.of(this).size;

  double get width => size.width;

  double get height => size.height;

  /// ⌨️ Keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
