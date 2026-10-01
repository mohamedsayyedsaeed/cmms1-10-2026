import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Tailwind `animate-pulse`: opacity 1 -> 0.5 -> 1 (2s, ease-in-out, infinite).
class Pulse extends StatefulWidget {
  const Pulse({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.delay = Duration.zero,
    this.minOpacity = 0.5,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double minOpacity;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration ~/ 2);
    if (widget.delay == Duration.zero) {
      _c.repeat(reverse: true);
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double v = Curves.easeInOut.transform(_c.value);
        return Opacity(
          opacity: 1 - (1 - widget.minOpacity) * v,
          child: child,
        );
      },
    );
  }
}

/// Tailwind `animate-ping`: scales up to 2x while fading out (1s, infinite).
class Ping extends StatefulWidget {
  const Ping({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.maxScale = 2.0,
  });

  final Widget child;
  final Duration delay;
  final double maxScale;

  @override
  State<Ping> createState() => _PingState();
}

class _PingState extends State<Ping> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    if (widget.delay == Duration.zero) {
      _c.repeat();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.repeat();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        // Reaches full scale / zero opacity at 75%, then rests (like Tailwind).
        final double v = Curves.easeOut.transform(math.min(1.0, _c.value / 0.75));
        return Opacity(
          opacity: 1 - v,
          child: Transform.scale(
            scale: 1 + (widget.maxScale - 1) * v,
            child: child,
          ),
        );
      },
    );
  }
}

/// Fade in while rising 10px (the prototype's `animate-fade-in`), with optional delay.
class FadeInUp extends StatefulWidget {
  const FadeInUp({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(seconds: 1),
    this.offset = 10,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    if (widget.delay == Duration.zero) {
      _c.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double v = Curves.easeInOut.transform(_c.value);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * widget.offset),
            child: child,
          ),
        );
      },
    );
  }
}

/// The prototype's `animate-scale-in`: scale 0.9 -> 1 while fading in.
class ScaleIn extends StatelessWidget {
  const ScaleIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOut,
      child: child,
      builder: (BuildContext context, double v, Widget? child) {
        return Opacity(
          opacity: v,
          child: Transform.scale(scale: 0.9 + 0.1 * v, child: child),
        );
      },
    );
  }
}

/// Continuous up/down float (`animate-float`: 0 -> -20px -> 0 over 6s).
class Float extends StatefulWidget {
  const Float({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.distance = 20,
  });

  final Widget child;
  final Duration delay;
  final double distance;

  @override
  State<Float> createState() => _FloatState();
}

class _FloatState extends State<Float> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 6));
    if (widget.delay == Duration.zero) {
      _c.repeat();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.repeat();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double y = -widget.distance * math.sin(math.pi * _c.value);
        return Transform.translate(offset: Offset(0, y), child: child);
      },
    );
  }
}

/// One falling column of binary digits for [BinaryRain] (`animate-binary-fall`:
/// translateY -100% -> 100vh over 15s linear, fading in over the first 10% and
/// out over the last 10%).
class _BinaryColumn extends StatefulWidget {
  const _BinaryColumn({required this.leftFraction, required this.delay, required this.lines});

  final double leftFraction;
  final Duration delay;
  final List<String> lines;

  @override
  State<_BinaryColumn> createState() => _BinaryColumnState();
}

class _BinaryColumnState extends State<_BinaryColumn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 15));
    Future<void>.delayed(widget.delay, () {
      if (mounted) _c.repeat();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double columnHeight = widget.lines.length * 23.0; // ~16px mono lines at 1.45 line-height
        final double travel = constraints.maxHeight + columnHeight;
        return AnimatedBuilder(
          animation: _c,
          builder: (BuildContext context, Widget? child) {
            final double v = _c.value;
            final double opacity = v < 0.10
                ? v / 0.10
                : v > 0.90
                    ? (1 - v) / 0.10
                    : 1.0;
            final double y = -columnHeight + travel * v;
            // A Stack here (rather than returning Positioned straight from this
            // builder) gives Positioned a direct Stack ancestor of its own —
            // it can't reach past the LayoutBuilder/AnimatedBuilder above to the
            // outer BinaryRain Stack.
            return Stack(
              children: <Widget>[
                Positioned(
                  left: constraints.maxWidth * widget.leftFraction,
                  top: y,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Text(
                      widget.lines.join('\n'),
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// The login screen's faint falling-binary-digits backdrop: 5 columns at
/// 10/30/50/70/90% width, staggered delays, overall dimmed to 10% opacity.
class BinaryRain extends StatelessWidget {
  const BinaryRain({super.key});

  static const List<List<String>> _columns = <List<String>>[
    <String>['01001001', '10110010', '11010101', '00101110', '10011100'],
    <String>['11001010', '01010111', '10101100', '11100011', '01011001'],
    <String>['10110101', '01101001', '11010010', '00111011', '10100110'],
    <String>['01110010', '10011101', '11000110', '01010011', '10101111'],
    <String>['11010110', '00101101', '10110011', '01111000', '11001001'],
  ];

  static const List<double> _lefts = <double>[0.10, 0.30, 0.50, 0.70, 0.90];
  static const List<Duration> _delays = <Duration>[
    Duration.zero,
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 1),
    Duration(seconds: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.10,
      child: Stack(
        children: List<Widget>.generate(_columns.length, (int i) {
          // Positioned.fill gives each column the full area to measure against
          // (it needs the total height to compute its own fall distance), while
          // still being a proper direct Stack child itself.
          return Positioned.fill(
            child: _BinaryColumn(leftFraction: _lefts[i], delay: _delays[i], lines: _columns[i]),
          );
        }),
      ),
    );
  }
}

/// Three dots bouncing in sequence (`animate-bounce` with 0 / 0.2s / 0.4s delays).
class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key, required this.color, this.size = 8});

  final Color color;
  final double size;

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(3, (int i) {
            final double phase = (_c.value - i * 0.2) % 1.0;
            final double y = -widget.size * 1.2 * math.sin(math.pi * phase);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.size / 4),
              child: Transform.translate(
                offset: Offset(0, y),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration:
                      BoxDecoration(color: widget.color, shape: BoxShape.circle),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
