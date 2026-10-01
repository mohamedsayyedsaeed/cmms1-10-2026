import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';

/// The prototype's `<IconButton>`: rounded-xl, minimum 44x44 touch target.
class IconBtn extends StatelessWidget {
  const IconBtn({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.iconSize = 24,
    this.background,
    this.color,
    this.borderColor,
    this.radius = 12,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? background;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final double box = math.max(size, 44);
    final Widget button = SizedBox(
      width: box,
      height: box,
      child: Material(
        color: background ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: color ??
                  (context.isDark ? Tw.gray.shade300 : Tw.gray.shade700),
            ),
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
