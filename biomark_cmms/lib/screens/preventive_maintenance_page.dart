import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_widgets.dart';
import '../widgets/tone_boxes.dart';

/// PreventiveMaintenancePage.tsx: 8 hardcoded PM tasks, most recent first.
class PreventiveMaintenancePage extends StatelessWidget {
  const PreventiveMaintenancePage({super.key});

  static final List<PmTask> tasks = <PmTask>[
    PmTask(id: 'PM-001', taskNumber: 'PM-2024-001', deviceName: 'Ventilator - Model V300', deviceCode: 'VNT-2024-001', location: 'ICU - Room 205', startDate: DateTime(2024, 1, 15), dueDate: DateTime(2024, 1, 12), isOverdue: true),
    PmTask(id: 'PM-002', taskNumber: 'PM-2024-002', deviceName: 'Patient Monitor - PM500', deviceCode: 'MON-2024-045', location: 'Emergency - Station 3', startDate: DateTime(2024, 1, 14), dueDate: DateTime(2024, 1, 20), isOverdue: false),
    PmTask(id: 'PM-003', taskNumber: 'PM-2024-003', deviceName: 'Infusion Pump - IP200', deviceCode: 'INF-2024-089', location: 'Operating Room 2', startDate: DateTime(2024, 1, 13), dueDate: DateTime(2024, 1, 22), isOverdue: false),
    PmTask(id: 'PM-004', taskNumber: 'PM-2024-004', deviceName: 'Defibrillator - DF300', deviceCode: 'DEF-2024-012', location: 'General Ward - Floor 3', startDate: DateTime(2024, 1, 12), dueDate: DateTime(2024, 1, 9), isOverdue: true),
    PmTask(id: 'PM-005', taskNumber: 'PM-2024-005', deviceName: 'X-Ray Machine - XR400', deviceCode: 'XRY-2024-003', location: 'Radiology Department', startDate: DateTime(2024, 1, 11), dueDate: DateTime(2024, 1, 25), isOverdue: false),
    PmTask(id: 'PM-006', taskNumber: 'PM-2024-006', deviceName: 'Ultrasound - US500', deviceCode: 'ULS-2024-021', location: 'Obstetrics - Room 8', startDate: DateTime(2024, 1, 10), dueDate: DateTime(2024, 1, 28), isOverdue: false),
    PmTask(id: 'PM-007', taskNumber: 'PM-2024-007', deviceName: 'ECG Machine - ECG600', deviceCode: 'ECG-2024-055', location: 'Cardiology - Station 2', startDate: DateTime(2024, 1, 9), dueDate: DateTime(2024, 1, 30), isOverdue: false),
    PmTask(id: 'PM-008', taskNumber: 'PM-2024-008', deviceName: 'Anesthesia Machine - AM400', deviceCode: 'ANS-2024-007', location: 'Operating Room 5', startDate: DateTime(2024, 1, 8), dueDate: DateTime(2024, 2, 1), isOverdue: false),
  ];

  @override
  Widget build(BuildContext context) {
    final int overdue = tasks.where((PmTask t) => t.isOverdue).length;
    final int active = tasks.length - overdue;

    return DetailScaffold(
      header: ScreenHeader(
        title: context.t('preventiveMaintenance'),
        subtitle: context.t('assignedTasks'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('${tasks.length}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Tone.purple.iconFg(context.isDark))),
            Text(context.t('tasksAssigned'), style: TextStyle(fontSize: 11, color: context.textSecondary)),
          ],
        ),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: EmptyState(icon: AppIcons.wrench, title: context.t('noPMAssigned'), message: context.t('noData')),
              ),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
              children: <Widget>[
                AppCard(
                  gradient: Tone.purple.soft(context.isDark),
                  borderColor: Tone.purple.border(context.isDark),
                  borderWidth: 2,
                  child: Row(
                    children: <Widget>[
                      const ToneIconBox(icon: AppIcons.wrench, tone: Tone.purple, size: 48, iconSize: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(context.t('assignedPM'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Tone.purple.textStrong(context.isDark))),
                            Text(
                              '$overdue ${context.t('overdueTask').toLowerCase()} • $active ${context.t('active').toLowerCase()}',
                              style: TextStyle(fontSize: 12, color: Tone.purple.textMid(context.isDark)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...tasks.map((PmTask task) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      gradient: task.isOverdue ? Tone.red.soft(context.isDark) : null,
                      borderColor: task.isOverdue ? Tone.red.border(context.isDark) : context.borderColor,
                      borderWidth: task.isOverdue ? 2 : 1,
                      onTap: () => context.go('/preventive-maintenance/${task.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ToneIconBox(icon: AppIcons.wrench, tone: task.isOverdue ? Tone.red : Tone.purple, size: 48, iconSize: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Text(task.taskNumber, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary)),
                                    if (task.isOverdue) ...<Widget>[
                                      const SizedBox(width: 8),
                                      OverdueChip(label: context.t('overdueTask')),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _kv(context, AppIcons.wrench, context.t('deviceName'), task.deviceName),
                          const SizedBox(height: 8),
                          _kv(context, AppIcons.hash, context.t('deviceCode'), task.deviceCode),
                          const SizedBox(height: 8),
                          _kv(context, AppIcons.mapPin, context.t('location'), task.location),
                          const SizedBox(height: 12),
                          DateTilePair(
                            startLabel: context.t('startDate'),
                            startText: context.dateMedium(task.startDate),
                            dueLabel: context.t('dueDate'),
                            dueText: context.dateMedium(task.dueDate),
                            overdue: task.isOverdue,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
                            child: AppBadge(
                              task.isOverdue ? context.t('overdueTask') : context.t('active'),
                              variant: task.isOverdue ? BadgeVariant.danger : BadgeVariant.purple,
                              small: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _kv(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(top: 2), child: Icon(icon, size: 16, color: context.textSecondary)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
              Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}
