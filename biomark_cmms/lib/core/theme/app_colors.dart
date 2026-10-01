import 'package:flutter/material.dart';

/// Brand tokens from tailwind.config.js.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00619F);
  static const Color primaryDark = Color(0xFF004A7C);
  static const Color primaryLight = Color(0xFF0077C2);

  static const Color accent = Color(0xFF8BC53F);
  static const Color accentDark = Color(0xFF6FA030);
  static const Color accentLight = Color(0xFFA5D65E);

  static const Color navy = Color(0xFF1A2332);
  static const Color navyLight = Color(0xFF2A3442);
  static const Color navyDark = Color(0xFF0F1419);

  // Splash + login backgrounds (hard-coded hex values in the prototype).
  static const Color brandBlue = Color(0xFF0D79BD);
  static const Color brandBlueMid = Color(0xFF0A5A8F);
  static const Color brandBlueDeep = Color(0xFF073D61);
}

extension ColorOpacityX on Color {
  /// Tailwind-style opacity modifier: `bg-primary/10` -> `AppColors.primary.op(0.1)`.
  Color op(double opacity) => withAlpha((opacity * 255).round());
}
