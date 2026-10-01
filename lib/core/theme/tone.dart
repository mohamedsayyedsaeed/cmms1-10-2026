import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'tw_colors.dart';

/// A Tailwind hue plus the light/dark shade recipes the prototype repeats everywhere
/// (e.g. `bg-blue-100 dark:bg-blue-900/20`, `text-blue-600 dark:text-blue-400`).
class Tone {
  const Tone(this.c);
  final MaterialColor c;

  static const Tone blue = Tone(Tw.blue);
  static const Tone red = Tone(Tw.red);
  static const Tone green = Tone(Tw.green);
  static const Tone yellow = Tone(Tw.yellow);
  static const Tone orange = Tone(Tw.orange);
  static const Tone purple = Tone(Tw.purple);
  static const Tone cyan = Tone(Tw.cyan);
  static const Tone indigo = Tone(Tw.indigo);
  static const Tone teal = Tone(Tw.teal);

  /// bg-x-100 dark:bg-x-900/20   (small icon chips)
  Color iconBg(bool dark) => dark ? c.shade900.op(0.2) : c.shade100;

  /// text-x-600 dark:text-x-400
  Color iconFg(bool dark) => dark ? c.shade400 : c.shade600;

  /// bg-x-50 dark:bg-x-900/20
  Color softBg(bool dark) => dark ? c.shade900.op(0.2) : c.shade50;

  /// border-x-200 dark:border-x-800
  Color border(bool dark) => dark ? c.shade800 : c.shade200;

  /// text-x-900 dark:text-x-300
  Color textStrong(bool dark) => dark ? c.shade300 : c.shade900;

  /// text-x-800 dark:text-x-400
  Color textMid(bool dark) => dark ? c.shade400 : c.shade800;

  /// text-x-700 dark:text-x-400
  Color textSub(bool dark) => dark ? c.shade400 : c.shade700;

  /// text-x-600 dark:text-x-400
  Color textAccent(bool dark) => dark ? c.shade400 : c.shade600;

  /// bg-gradient-to-br from-x-50 to-x-100/50  dark:from-x-900/20 dark:to-x-900/10
  LinearGradient soft(bool dark) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? [c.shade900.op(0.2), c.shade900.op(0.1)]
            : [c.shade50, c.shade100.op(0.5)],
      );

  /// bg-gradient-to-br from-x-500 to-x-600
  LinearGradient get solid => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c.shade500, c.shade600],
      );

  /// shadow-x-500/30
  Color get glow => c.shade500.op(0.3);
}

/// Brand gradients used by several widgets.
class Gradients {
  Gradients._();

  static const LinearGradient primarySolid = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  static const LinearGradient accentSolid = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.accent, AppColors.accentDark],
  );

  /// from-primary via-primary-dark to-navy
  static const LinearGradient headerBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryDark, AppColors.navy],
  );

  /// from-[#0d79bd] via-[#0a5a8f] to-[#073d61]
  static const LinearGradient brandScreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.brandBlue,
      AppColors.brandBlueMid,
      AppColors.brandBlueDeep,
    ],
  );
}
