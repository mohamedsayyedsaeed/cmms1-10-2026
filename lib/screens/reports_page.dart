import 'package:flutter/material.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/layout.dart';

class _Completion {
  const _Completion(this.id, this.asset, this.date, this.duration);
  final String id;
  final String asset;
  final String date;
  final String duration;
}

/// ReportsPage.tsx.
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  static const List<_Completion> _completions = <_Completion>[
    _Completion('WO-2024-001', 'Ventilator V300', '2024-01-15', '2.5h'),
    _Completion('WO-2024-003', 'Patient Monitor', '2024-01-14', '1.2h'),
    _Completion('WO-2024-005', 'Infusion Pump', '2024-01-14', '0.8h'),
  ];

  @override
  Widget build(BuildContext context) {
    return PageList(
      safeTop: true,
      gap: 24,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: PageTitle(context.t('reports'))),
            AppButton(label: context.t('export'), variant: ButtonVariant.outline, size: ButtonSize.sm, icon: AppIcons.download, onPressed: () {}),
          ],
        ),
        TwoColumnGrid(children: mockKpis.map((Kpi kpi) {
          final bool up = kpi.trend == Trend.up;
          return AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text(kpi.label, style: TextStyle(fontSize: 12, color: context.textSecondary))),
                    if (kpi.trend != null)
                      Icon(up ? AppIcons.trendingUp : AppIcons.trendingDown, size: 16, color: up ? Tw.green.shade600 : Tw.red.shade600),
                  ],
                ),
                const SizedBox(height: 4),
                Text(kpi.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimary)),
                if (kpi.change != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "${kpi.change! > 0 ? '+' : ''}${kpi.change} % from last month".replaceFirst(' %', '%'),
                      style: TextStyle(fontSize: 12, color: kpi.change! > 0 ? Tw.green.shade600 : Tw.red.shade600),
                    ),
                  ),
              ],
            ),
          );
        }).toList()),
        AppCard(
          borderColor: context.borderColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('My Completions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
              const SizedBox(height: 12),
              Column(
                children: spaced(_completions.map((_Completion c) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: const Color(0xFF8BC53F).withAlpha(26), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(AppIcons.fileText, color: Color(0xFF6FA030), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(c.id, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
                                  const SizedBox(width: 8),
                                  const AppBadge('Completed', variant: BadgeVariant.success, small: true),
                                ],
                              ),
                              Text(c.asset, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(c.date, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            Text(c.duration, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textPrimary)),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(), 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
