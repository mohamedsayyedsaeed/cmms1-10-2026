import 'package:flutter/material.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';

/// Red pill with a flag: the "Overdue" marker on task cards.
class OverdueChip extends StatelessWidget {
  const OverdueChip({super.key, required this.label, this.large = false});

  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 2,
      ),
      decoration: BoxDecoration(
        color: Tw.red.shade500,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(AppIcons.flag, size: large ? 16 : 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Start-date + due-date tile pair (`grid grid-cols-2 gap-3`); due turns red when overdue.
class DateTilePair extends StatelessWidget {
  const DateTilePair({
    super.key,
    required this.startLabel,
    required this.startText,
    required this.dueLabel,
    required this.dueText,
    required this.overdue,
  });

  final String startLabel;
  final String startText;
  final String dueLabel;
  final String dueText;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Tone t = overdue ? Tone.red : Tone.green;

    final Widget start = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.tileBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(AppIcons.calendar, size: 16, color: Tw.gray.shade400),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  startLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            startText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );

    final Widget due = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: overdue
            ? (dark ? Tw.red.shade900.op(0.3) : Tw.red.shade100)
            : (dark ? Tw.green.shade900.op(0.2) : Tw.green.shade50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(AppIcons.clock, size: 16, color: t.c.shade500),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  dueLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: dark ? t.c.shade400 : t.c.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            dueText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: dark ? t.c.shade300 : t.c.shade900,
            ),
          ),
        ],
      ),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: start),
          const SizedBox(width: 12),
          Expanded(child: due),
        ],
      ),
    );
  }
}

/// Big "card" shown on list pages when there is nothing to list.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return Column(
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: dark ? Tw.gray.shade800 : Tw.gray.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 32, color: Tw.gray.shade400),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(fontSize: 14, color: context.textSecondary),
        ),
      ],
    );
  }
}
