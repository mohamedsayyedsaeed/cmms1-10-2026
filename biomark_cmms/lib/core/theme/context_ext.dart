import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../utils/formatters.dart';
import 'app_colors.dart';
import 'tw_colors.dart';

// Anything that imports context_ext also gets the Tailwind-style `.op(0.5)` helper.
export 'app_colors.dart' show ColorOpacityX;

/// Space kept free at the bottom of scrollables for the floating bottom nav.
const double kNavClearance = 104;

/// Widest the app content grows (Tailwind `max-w-md`).
const double kMaxContentWidth = 448;

extension AppContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  // ----- semantic colors (the prototype's most common light/dark pairs) -----
  /// bg-gray-50 dark:bg-navy
  Color get pageBg => isDark ? AppColors.navy : Tw.gray.shade50;

  /// bg-white dark:bg-navy-light
  Color get cardBg => isDark ? AppColors.navyLight : Colors.white;

  /// text-gray-900 dark:text-white
  Color get textPrimary => isDark ? Colors.white : Tw.gray.shade900;

  /// text-gray-600 dark:text-gray-400
  Color get textSecondary => isDark ? Tw.gray.shade400 : Tw.gray.shade600;

  /// border-gray-200 dark:border-gray-700
  Color get borderColor => isDark ? Tw.gray.shade700 : Tw.gray.shade200;

  /// bg-gray-50 dark:bg-navy   (info tiles inside cards)
  Color get tileBg => isDark ? AppColors.navy : Tw.gray.shade50;

  /// bg-gray-100 dark:bg-navy
  Color get chipBg => isDark ? AppColors.navy : Tw.gray.shade100;

  // ----- app state -----
  /// Translate (rebuilds when the language changes). Call from `build`.
  String t(String key) => Provider.of<AppState>(this).t(key);

  /// Translate without subscribing. Use inside callbacks.
  String tRead(String key) => Provider.of<AppState>(this, listen: false).t(key);

  String get lang => Provider.of<AppState>(this).language;
  bool get isArabic => Provider.of<AppState>(this).isArabic;

  // ----- date formatting in the current app language -----
  String dateShort(DateTime d) => Fmt.dateShort(d, lang);
  String dateMedium(DateTime d) => Fmt.dateMedium(d, lang);
  String dateLong(DateTime d) => Fmt.dateLong(d, lang);
  String timeOf(DateTime d) => Fmt.time(d, lang);

  /// Bottom padding for scrollables: clears the floating nav + system inset.
  double get navBottomPad => kNavClearance + MediaQuery.paddingOf(this).bottom;
}
