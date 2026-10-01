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

/// InspectionsPage.tsx: 5 hardcoded inspection tasks, most recent first.
class InspectionsPage extends StatelessWidget {
  const InspectionsPage({super.key});

  static final List<InspectionTask> tasks = <InspectionTask>[
    InspectionTask(
      id: 'INS-001',
      taskNumber: 'INS-2024-001',
      location: 'ICU - Room 205',
      startDate: DateTime(2024, 1, 15),
      dueDate: DateTime(2024, 1, 10),
      isOverdue: true,
    ),
    InspectionTask(
      id: 'INS-002',
      taskNumber: 'INS-2024-002',
      location: 'Emergency - Station 3',
      startDate: DateTime(2024, 1, 14),
      dueDate: DateTime(2024, 1, 20),
      isOverdue: false,
    ),
    InspectionTask(
      id: 'INS-003',
      taskNumber: 'INS-2024-003',
      location: 'Operating Room 2',
      startDate: DateTime(2024, 1, 13),
      dueDate: DateTime(2024, 1, 22),
      isOverdue: false,
    ),
    InspectionTask(
      id: 'INS-004',
      taskNumber: 'INS-2024-004',
      location: 'General Ward - Floor 3',
      startDate: DateTime(2024, 1, 12),
      dueDate: DateTime(2024, 1, 25),
      isOverdue: false,
    ),
    InspectionTask(
      id: 'INS-005',
      taskNumber: 'INS-2024-005',
      location: 'Radiology Department',
      startDate: DateTime(2024, 1, 10),
      dueDate: DateTime(2024, 1, 28),
      isOverdue: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int overdue = tasks.where((InspectionTask t) => t.isOverdue).length;
    final int active = tasks.length - overdue;

    return DetailScaffold(
      header: ScreenHeader(
        title: context.t('inspections'),
        subtitle: context.t('assignedTasks'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('${tasks.length}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Tone.blue.iconFg(context.isDark))),
            Text(context.t('tasksAssigned'), style: TextStyle(fontSize: 11, color: context.textSecondary)),
          ],
        ),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: EmptyState(icon: AppIcons.clipboardCheck, title: context.t('noInspectionsAssigned'), message: context.t('noData')),
              ),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
              children: <Widget>[
                AppCard(
                  gradient: Tone.blue.soft(context.isDark),
                  borderColor: Tone.blue.border(context.isDark),
                  borderWidth: 2,
                  child: Row(
                    children: <Widget>[
                      const ToneIconBox(icon: AppIcons.clipboardCheck, tone: Tone.blue, size: 48, iconSize: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(context.t('assignedInspections'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Tone.blue.textStrong(context.isDark))),
                            Text(
                              '$overdue ${context.t('overdueTask').toLowerCase()} • $active ${context.t('active').toLowerCase()}',
                              style: TextStyle(fontSize: 12, color: Tone.blue.textMid(context.isDark)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...tasks.map((InspectionTask task) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      gradient: task.isOverdue ? Tone.red.soft(context.isDark) : null,
                      borderColor: task.isOverdue ? Tone.red.border(context.isDark) : context.borderColor,
                      borderWidth: task.isOverdue ? 2 : 1,
                      onTap: () => context.go('/inspections/${task.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ToneIconBox(
                                icon: AppIcons.clipboardCheck,
                                tone: task.isOverdue ? Tone.red : Tone.blue,
                                size: 48,
                                iconSize: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(task.taskNumber, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary)),
                                        if (task.isOverdue) ...<Widget>[
                                          const SizedBox(width: 8),
                                          OverdueChip(label: context.t('overdueTask')),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: <Widget>[
                                        Icon(AppIcons.mapPin, size: 14, color: context.textSecondary),
                                        const SizedBox(width: 6),
                                        Expanded(child: Text(task.location, style: TextStyle(fontSize: 12, color: context.textSecondary))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                              variant: task.isOverdue ? BadgeVariant.danger : BadgeVariant.primary,
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
}
