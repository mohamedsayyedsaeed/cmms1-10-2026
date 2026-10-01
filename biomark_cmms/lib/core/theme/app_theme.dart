import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'tw_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(String language) => _build(Brightness.light, language);
  static ThemeData dark(String language) => _build(Brightness.dark, language);

  static ThemeData _build(Brightness brightness, String language) {
    final bool dark = brightness == Brightness.dark;
    final ThemeData base = ThemeData(brightness: brightness, useMaterial3: true);

    // Poppins for English, Tajawal for Arabic (as in index.css).
    final TextTheme fontTheme = language == 'ar'
        ? GoogleFonts.tajawalTextTheme(base.textTheme)
        : GoogleFonts.poppinsTextTheme(base.textTheme);

    final Color onSurface = dark ? Colors.white : Tw.gray.shade900;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: Tw.red.shade600,
      surface: dark ? AppColors.navyLight : Colors.white,
      onSurface: onSurface,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? AppColors.navy : Tw.gray.shade50,
      canvasColor: dark ? AppColors.navy : Tw.gray.shade50,
      textTheme: fontTheme.apply(bodyColor: onSurface, displayColor: onSurface),
      splashFactory: InkRipple.splashFactory,
      dividerColor: dark ? Tw.gray.shade700 : Tw.gray.shade200,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
    );
  }
}
