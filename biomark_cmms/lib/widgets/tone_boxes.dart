import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';

/// Gradient rounded square with a colored glow, e.g.
/// `w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl shadow-lg shadow-blue-500/30`.
class ToneIconBox extends StatelessWidget {
  const ToneIconBox({
    super.key,
    required this.icon,
    this.tone,
    this.gradient,
    this.glowColor,
    this.size = 48,
    this.iconSize = 24,
    this.radius = 16,
  }) : assert(tone != null || (gradient != null && glowColor != null));

  final IconData icon;
  final Tone? tone;
  final Gradient? gradient;
  final Color? glowColor;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient ?? tone!.solid,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glowColor ?? tone!.glow,
            blurRadius: 15,
            spreadRadius: -3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}

/// Soft tinted rounded square: `w-10 h-10 rounded-xl bg-x-100 dark:bg-x-900/20` + colored icon.
class SoftIconBox extends StatelessWidget {
  const SoftIconBox({
    super.key,
    required this.icon,
    this.tone,
    this.bg,
    this.fg,
    this.size = 40,
    this.iconSize = 20,
    this.radius = 12,
  }) : assert(tone != null || (bg != null && fg != null));

  final IconData icon;
  final Tone? tone;
  final Color? bg;
  final Color? fg;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg ?? tone!.iconBg(dark),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: fg ?? tone!.iconFg(dark)),
    );
  }
}

/// The small vertical primary->accent bar that prefixes section titles.
class AccentBar extends StatelessWidget {
  const AccentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 24,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

/// `[AccentBar] Title` row used on the dashboard.
class AccentTitle extends StatelessWidget {
  const AccentTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const AccentBar(),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// `[icon chip] Title (optional subtitle)` — the header row inside most cards.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.tone,
    this.bg,
    this.fg,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Tone? tone;
  final Color? bg;
  final Color? fg;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SoftIconBox(icon: icon, tone: tone, bg: bg, fg: fg),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
