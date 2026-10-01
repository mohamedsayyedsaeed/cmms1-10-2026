import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import 'anim.dart';

/// Square grid of thin lines. [offsetY] scrolls it (used for the login "gridMove").
class GridPainter extends CustomPainter {
  GridPainter({
    required this.spacing,
    required this.color,
    this.strokeWidth = 1,
    this.offsetY = 0,
  });

  final double spacing;
  final Color color;
  final double strokeWidth;
  final double offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = offsetY - spacing; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(GridPainter old) =>
      old.offsetY != offsetY ||
      old.color != color ||
      old.spacing != spacing ||
      old.strokeWidth != strokeWidth;
}

/// Polka-dot grid: `radial-gradient(circle at 2px 2px, currentColor 1px, transparent 0)`.
class DotGridPainter extends CustomPainter {
  DotGridPainter({required this.color, this.spacing = 32});

  final Color color;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()..color = color;
    for (double y = 2; y <= size.height; y += spacing) {
      for (double x = 2; x <= size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(DotGridPainter old) =>
      old.color != color || old.spacing != spacing;
}

/// Soft glowing blob — a radial gradient standing in for `blur-3xl` circles.
class GlowOrb extends StatelessWidget {
  const GlowOrb({super.key, required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: <Color>[color, color.op(0)]),
      ),
    );
  }
}

/// Backdrop for every screen inside the shell (AppShell.tsx):
/// soft gradient + dot grid + three pulsing orbs + two corner accents.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Color mid = Color.alphaBlend(
      Tw.blue.shade50.op(0.3),
      Tw.gray.shade50,
    );
    final double top = MediaQuery.paddingOf(context).top + 16;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? <Color>[AppColors.navyDark, AppColors.navy, AppColors.navyDark]
                  : <Color>[Tw.gray.shade50, mid, Tw.gray.shade50],
            ),
          ),
        ),
        CustomPaint(
          painter: DotGridPainter(
            color: (dark ? Colors.white : Colors.black).op(dark ? 0.05 : 0.02),
          ),
        ),
        PositionedDirectional(
          top: -96,
          end: -96,
          child: Pulse(child: GlowOrb(color: AppColors.primary.op(0.10), size: 384)),
        ),
        PositionedDirectional(
          bottom: -96,
          start: -96,
          child: Pulse(
            delay: const Duration(seconds: 1),
            child: GlowOrb(color: AppColors.accent.op(0.10), size: 384),
          ),
        ),
        Center(
          child: Pulse(
            delay: const Duration(milliseconds: 500),
            child: GlowOrb(color: Tw.cyan.shade400.op(0.10), size: 256),
          ),
        ),
        PositionedDirectional(
          top: top,
          start: 16,
          child: _Corner(color: AppColors.primary.op(0.10), flipped: false),
        ),
        PositionedDirectional(
          top: top,
          end: 16,
          child: _Corner(color: AppColors.accent.op(0.10), flipped: true),
        ),
      ],
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.color, required this.flipped});

  final Color color;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: <Widget>[
          PositionedDirectional(
            top: 0,
            start: flipped ? null : 0,
            end: flipped ? 0 : null,
            child: Container(width: 64, height: 2, color: color),
          ),
          PositionedDirectional(
            top: 0,
            start: flipped ? null : 0,
            end: flipped ? 0 : null,
            child: Container(width: 2, height: 64, color: color),
          ),
        ],
      ),
    );
  }
}
