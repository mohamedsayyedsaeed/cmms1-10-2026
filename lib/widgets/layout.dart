import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';

/// Inserts [gap] between children (Tailwind `space-y-*`).
List<Widget> spaced(List<Widget> children, double gap) {
  final List<Widget> out = <Widget>[];
  for (int i = 0; i < children.length; i++) {
    if (i > 0) out.add(SizedBox(height: gap));
    out.add(children[i]);
  }
  return out;
}

/// Scrollable page body with the standard `p-4 space-y-*` padding, clearing the
/// floating bottom nav. Set [safeTop] for pages without their own header.
class PageList extends StatelessWidget {
  const PageList({
    super.key,
    required this.children,
    this.gap = 16,
    this.safeTop = false,
    this.padding = 16,
    this.bottomExtra = 0,
  });

  final List<Widget> children;
  final double gap;
  final bool safeTop;
  final double padding;
  final double bottomExtra;

  @override
  Widget build(BuildContext context) {
    final double top = padding + (safeTop ? MediaQuery.paddingOf(context).top : 0);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        padding,
        top,
        padding,
        context.navBottomPad + bottomExtra,
      ),
      children: spaced(children, gap),
    );
  }
}

/// Two equal columns (`grid grid-cols-2 gap-3`) whose rows share the tallest height.
class TwoColumnGrid extends StatelessWidget {
  const TwoColumnGrid({super.key, required this.children, this.gap = 12});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i += 2) {
      final Widget first = children[i];
      final Widget second =
          i + 1 < children.length ? children[i + 1] : const SizedBox.shrink();
      if (i > 0) rows.add(SizedBox(height: gap));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: first),
              SizedBox(width: gap),
              Expanded(child: second),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// Small page-level heading (`text-2xl font-bold`).
class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: context.textPrimary,
      ),
    );
  }
}
