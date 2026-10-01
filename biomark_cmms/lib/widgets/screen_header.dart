import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/router/nav.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import 'icon_btn.dart';

/// White/navy detail-page header: back button, title, subtitle, optional trailing.
/// (`bg-white dark:bg-navy-light border-b p-4 sticky top-0`.) Place it above an
/// `Expanded` scroll view so it stays fixed.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// Extra content under the title row (progress bars).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 16,
          16,
          16,
        ),
        decoration: BoxDecoration(
          color: context.cardBg,
          border: Border(bottom: BorderSide(color: context.borderColor)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconBtn(
                  icon: AppIcons.arrowBack,
                  onPressed: onBack ?? () => goBack(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            if (bottom != null) ...<Widget>[
              const SizedBox(height: 12),
              bottom!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Colored gradient header (Settings, Maintenance Details).
class GradientScreenHeader extends StatelessWidget {
  const GradientScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradient,
    this.bottomPadding = 32,
  });

  final String title;
  final String subtitle;
  final Gradient? gradient;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 16,
          16,
          bottomPadding,
        ),
        decoration: BoxDecoration(
          gradient: gradient ?? Gradients.headerBlue,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.op(0.15),
              blurRadius: 15,
              spreadRadius: -3,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            IconBtn(
              icon: AppIcons.arrowBack,
              onPressed: () => goBack(context),
              background: Colors.white.op(0.1),
              borderColor: Colors.white.op(0.2),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.white.op(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wraps a detail screen: page background + fixed header + scrolling body.
class DetailScaffold extends StatelessWidget {
  const DetailScaffold({super.key, required this.header, required this.body});

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.pageBg,
      child: Column(
        children: <Widget>[
          header,
          Expanded(child: body),
        ],
      ),
    );
  }
}
