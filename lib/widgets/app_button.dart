import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/context_ext.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.loading = false,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool loading;
  final IconData? icon;

  /// Stretches to the parent's width. Only use where the parent gives bounded
  /// width (a Column, or inside an Expanded within a Row).
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final bool disabled = onPressed == null || loading;

    Color? bg;
    Color fg;
    BorderSide side = BorderSide.none;
    bool filled = false;
    switch (variant) {
      case ButtonVariant.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        filled = true;
        break;
      case ButtonVariant.secondary:
        bg = AppColors.accent;
        fg = Colors.white;
        filled = true;
        break;
      case ButtonVariant.outline:
        fg = dark ? AppColors.primaryLight : AppColors.primary;
        side = BorderSide(color: fg, width: 2);
        break;
      case ButtonVariant.ghost:
        fg = dark ? AppColors.primaryLight : AppColors.primary;
        break;
    }

    late final double padH;
    late final double padV;
    late final double fontSize;
    late final double minH;
    switch (size) {
      case ButtonSize.sm:
        padH = 12;
        padV = 8;
        fontSize = 14;
        minH = 36;
        break;
      case ButtonSize.md:
        padH = 16;
        padV = 12;
        fontSize = 16;
        minH = 44;
        break;
      case ButtonSize.lg:
        padH = 24;
        padV = 16;
        fontSize = 18;
        minH = 52;
        break;
    }

    final Widget row = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (loading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        else if (icon != null)
          Icon(icon, size: fontSize + 2, color: fg),
        if (loading || icon != null) const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: bg ?? Colors.transparent,
        elevation: filled ? 1 : 0,
        shadowColor: Colors.black.op(0.3),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: side,
        ),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minH),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}
