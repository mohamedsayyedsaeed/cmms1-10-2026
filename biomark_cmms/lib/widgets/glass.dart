import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';

/// Frosted-glass panel: `bg-white/10 backdrop-blur border border-white/20`.
class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    required this.child,
    this.radius = 16,
    this.blur = 12,
    this.color,
    this.borderColor,
    this.padding,
    this.shadow = true,
  });

  final Widget child;
  final double radius;
  final double blur;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        borderRadius: br,
        boxShadow: shadow
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.op(0.15),
                  blurRadius: 15,
                  spreadRadius: -3,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Colors.white.op(0.1),
              borderRadius: br,
              border: Border.all(color: borderColor ?? Colors.white.op(0.2)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
