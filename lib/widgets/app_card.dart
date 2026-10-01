import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/context_ext.dart';

enum CardPadding { none, sm, md, lg }

enum CardShadow { none, card, lg }

/// The prototype's `<Card>`: `bg-white dark:bg-navy-light rounded-card shadow-card`.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = CardPadding.md,
    this.onTap,
    this.color,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
    this.leftAccent,
    this.shadow = CardShadow.card,
    this.radius = 16,
  });

  final Widget child;
  final CardPadding padding;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;

  /// Replaces Tailwind's `border-l-4 border-l-*` (Flutter can't round a
  /// non-uniform border). Drawn on the leading edge, so it flips in RTL.
  final Color? leftAccent;
  final CardShadow shadow;
  final double radius;

  EdgeInsets get _padding {
    switch (padding) {
      case CardPadding.none:
        return EdgeInsets.zero;
      case CardPadding.sm:
        return const EdgeInsets.all(12);
      case CardPadding.md:
        return const EdgeInsets.all(16);
      case CardPadding.lg:
        return const EdgeInsets.all(24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final BorderRadius br = BorderRadius.circular(radius);

    Widget content = Padding(padding: _padding, child: child);
    if (leftAccent != null) {
      content = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(width: 4, color: leftAccent),
            Expanded(child: content),
          ],
        ),
      );
    }

    final Widget tappable = onTap == null
        ? content
        : InkWell(onTap: onTap, borderRadius: br, child: content);

    List<BoxShadow>? shadows;
    switch (shadow) {
      case CardShadow.none:
        shadows = null;
        break;
      case CardShadow.card:
        shadows = <BoxShadow>[
          BoxShadow(
            color: Colors.black.op(dark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
        break;
      case CardShadow.lg:
        shadows = <BoxShadow>[
          BoxShadow(
            color: Colors.black.op(dark ? 0.35 : 0.10),
            blurRadius: 15,
            spreadRadius: -3,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.op(dark ? 0.35 : 0.10),
            blurRadius: 6,
            spreadRadius: -4,
            offset: const Offset(0, 4),
          ),
        ];
        break;
    }

    return Container(
      decoration: BoxDecoration(borderRadius: br, boxShadow: shadows),
      child: ClipRRect(
        borderRadius: br,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              color: gradient == null
                  ? (color ?? (dark ? AppColors.navyLight : Colors.white))
                  : null,
              gradient: gradient,
              borderRadius: br,
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
            ),
            child: tappable,
          ),
        ),
      ),
    );
  }
}
