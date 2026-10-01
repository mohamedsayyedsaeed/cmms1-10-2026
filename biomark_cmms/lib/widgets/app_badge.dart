import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';

/// `purple` replaces the prototype's `'secondary'` variant, which was passed by
/// several screens but never defined in Badge (so those badges rendered unstyled).
enum BadgeVariant { primary, success, warning, danger, info, neutral, purple }

class AppBadge extends StatelessWidget {
  const AppBadge(
    this.label, {
    super.key,
    this.variant = BadgeVariant.neutral,
    this.small = false,
  });

  final String label;
  final BadgeVariant variant;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    Color bg;
    Color fg;
    switch (variant) {
      case BadgeVariant.primary:
        bg = AppColors.primary.op(dark ? 0.2 : 0.1);
        fg = AppColors.primary;
        break;
      case BadgeVariant.success:
        bg = AppColors.accent.op(dark ? 0.2 : 0.1);
        fg = AppColors.accentDark;
        break;
      case BadgeVariant.warning:
        bg = dark ? Tw.yellow.shade900.op(0.3) : Tw.yellow.shade100;
        fg = dark ? Tw.yellow.shade400 : Tw.yellow.shade700;
        break;
      case BadgeVariant.danger:
        bg = dark ? Tw.red.shade900.op(0.3) : Tw.red.shade100;
        fg = dark ? Tw.red.shade400 : Tw.red.shade700;
        break;
      case BadgeVariant.info:
        bg = dark ? Tw.blue.shade900.op(0.3) : Tw.blue.shade100;
        fg = dark ? Tw.blue.shade400 : Tw.blue.shade700;
        break;
      case BadgeVariant.neutral:
        bg = dark ? Tw.gray.shade800 : Tw.gray.shade100;
        fg = dark ? Tw.gray.shade300 : Tw.gray.shade700;
        break;
      case BadgeVariant.purple:
        bg = dark ? Tw.purple.shade900.op(0.3) : Tw.purple.shade100;
        fg = dark ? Tw.purple.shade400 : Tw.purple.shade700;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: small ? 12 : 14,
          height: small ? 16 / 12 : 20 / 14,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}
