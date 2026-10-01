import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/tone.dart';
import '../widgets/anim.dart';
import '../widgets/backgrounds.dart';

/// SplashScreen.tsx: animated circuit-board splash, auto-navigates to /login after 3s.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBlue,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(decoration: BoxDecoration(gradient: Gradients.brandScreen)),
          Opacity(
            opacity: 0.2,
            child: CustomPaint(painter: GridPainter(spacing: 50, color: Colors.cyanAccent.op(0.1))),
          ),
          ..._nodes(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _LogoFrame(),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'BIOMARK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'HEALTHCARE CMMS PLATFORM',
                          style: TextStyle(
                            color: Colors.cyan.shade100,
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _LoadingBars(),
                        const SizedBox(width: 12),
                        Text(
                          'INITIALIZING...',
                          style: TextStyle(
                            color: Colors.white.op(0.6),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 900),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.op(0.1),
                        border: Border.all(color: Colors.cyanAccent.op(0.2)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Pulse(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.cyanAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'v1.0.0',
                            style: TextStyle(
                              color: Colors.white.op(0.6),
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _nodes() {
    const List<(double, double, double, bool)> spots = <(double, double, double, bool)>[
      (0.20, 0.10, 3, false),
      (0.20, 0.85, 2, false),
      (0.50, 0.20, 2, false),
      (0.50, 0.80, 3, false),
      (0.80, 0.15, 2, false),
      (0.80, 0.90, 3, false),
      (0.05, 0.10, 2, true),
      (0.95, 0.10, 2, true),
      (0.05, 0.90, 2, true),
      (0.95, 0.90, 2, true),
    ];
    return spots.map((r) {
      final Widget dot = Container(
        width: r.$3,
        height: r.$3,
        decoration: BoxDecoration(
          color: Colors.cyanAccent,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.cyanAccent.op(0.5), blurRadius: 8)],
        ),
      );
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: FractionallySizedBox(
          alignment: Alignment(r.$1 * 2 - 1, r.$2 * 2 - 1),
          widthFactor: 0.001,
          heightFactor: 0.001,
          child: r.$4 ? Ping(child: dot) : Pulse(child: dot),
        ),
      );
    }).toList();
  }
}

class _LogoFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Pulse(
          duration: const Duration(seconds: 3),
          child: Container(
            width: 220,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: RadialGradient(
                colors: <Color>[Colors.cyanAccent.op(0.2), Colors.transparent],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.op(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.cyanAccent.op(0.3), width: 2),
          ),
          child: ScaleIn(
            child: Image.asset('assets/images/biomark_logo.png', width: 160),
          ),
        ),
      ],
    );
  }
}

class _LoadingBars extends StatefulWidget {
  @override
  State<_LoadingBars> createState() => _LoadingBarsState();
}

class _LoadingBarsState extends State<_LoadingBars> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<double> heights = <double>[16, 24, 32, 24, 16];
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(heights.length, (int i) {
            final double phase = (_c.value + i * 0.1) % 1.0;
            final double opacity = 0.6 + 0.4 * math.sin(phase * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: 4,
                height: heights[i],
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.op(opacity.clamp(0.4, 1.0)),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
