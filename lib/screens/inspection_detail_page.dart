import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../data/models.dart';
import '../state/inspection_progress.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_widgets.dart';
import '../widgets/tone_boxes.dart';

/// InspectionDetailPage.tsx.
class InspectionDetailPage extends StatelessWidget {
  const InspectionDetailPage({super.key, required this.id});

  final String id;

  static InspectionDetail _mock(String id) {
    return InspectionDetail(
      id: id,
      taskNumber: 'INS-2024-001',
      location: 'ICU - Room 205',
      startDate: DateTime(2024, 1, 15),
      dueDate: DateTime(2024, 1, 10),
      isOverdue: true,
      description:
          'Routine safety inspection of all medical equipment in ICU Room 205. Check for proper functioning, safety compliance, and maintenance requirements.',
      priority: 'high',
      assignedTo: 'Ahmed Al-Mansouri',
      createdDate: DateTime(2024, 1, 8),
      estimatedDuration: 3,
      status: 'pending',
      equipment: const <Equipment>[
        Equipment(id: 'EQ-001', name: 'Ventilator', code: 'VNT-2024-001', serialNumber: 'SN-VNT-45678', model: 'Model V300', location: 'ICU - Room 205'),
        Equipment(id: 'EQ-002', name: 'Patient Monitor', code: 'MON-2024-045', serialNumber: 'SN-MON-12345', model: 'PM500', location: 'ICU - Room 205'),
        Equipment(id: 'EQ-003', name: 'Infusion Pump', code: 'INF-2024-089', serialNumber: 'SN-INF-78901', model: 'IP200', location: 'ICU - Room 205'),
        Equipment(id: 'EQ-004', name: 'Defibrillator', code: 'DEF-2024-012', serialNumber: 'SN-DEF-34567', model: 'DF300', location: 'ICU - Room 205'),
      ],
    );
  }

  BadgeVariant _priorityVariant(String p) {
    switch (p) {
      case 'critical':
        return BadgeVariant.danger;
      case 'high':
        return BadgeVariant.warning;
      case 'medium':
        return BadgeVariant.primary;
      default:
        return BadgeVariant.neutral;
    }
  }

  BadgeVariant _statusVariant(String s) {
    switch (s) {
      case 'completed':
        return BadgeVariant.success;
      case 'in-progress':
        return BadgeVariant.primary;
      default:
        return BadgeVariant.neutral;
    }
  }

  void _openEquipment(BuildContext context, InspectionDetail detail, String equipmentId) {
    final String param = detail.equipment.map((Equipment e) => e.id).join(',');
    context.go('/inspections/${detail.id}/equipment/$equipmentId?equipment=$param');
  }

  @override
  Widget build(BuildContext context) {
    final InspectionDetail detail = _mock(id);
    final InspectionProgress progress = context.watch<InspectionProgress>();
    final int completedCount = progress.completedFor(detail.id).length;
    final int pendingCount = detail.equipment.length - completedCount;

    return DetailScaffold(
      header: ScreenHeader(
        title: detail.taskNumber,
        subtitle: context.t('inspectionDetails'),
        trailing: detail.isOverdue ? OverdueChip(label: context.t('overdueTask'), large: true) : null,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
        children: <Widget>[
          AppCard(
            gradient: (detail.isOverdue ? Tone.red : Tone.blue).soft(context.isDark),
            borderColor: (detail.isOverdue ? Tone.red : Tone.blue).border(context.isDark),
            borderWidth: 2,
            child: Row(
              children: <Widget>[
                ToneIconBox(icon: AppIcons.clipboardCheck, tone: detail.isOverdue ? Tone.red : Tone.blue, size: 48, iconSize: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.t('jobStatus'),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (detail.isOverdue ? Tone.red : Tone.blue).textStrong(context.isDark)),
                      ),
                      Text(context.t(detail.status), style: TextStyle(fontSize: 12, color: (detail.isOverdue ? Tone.red : Tone.blue).textMid(context.isDark))),
                    ],
                  ),
                ),
                AppBadge(context.t(detail.status), variant: _statusVariant(detail.status)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(icon: AppIcons.fileText, tone: Tone.blue, title: context.t('jobDetails')),
                const SizedBox(height: 16),
                InfoTile(icon: AppIcons.mapPin, label: context.t('location'), value: detail.location),
                const SizedBox(height: 12),
                InfoTile(
                  icon: AppIcons.alertCircle,
                  label: context.t('priority'),
                  valueWidget: AppBadge(context.t(detail.priority), variant: _priorityVariant(detail.priority), small: true),
                ),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.user, label: context.t('assignedTo'), value: detail.assignedTo),
                const SizedBox(height: 12),
                DateTilePair(
                  startLabel: context.t('startDate'),
                  startText: context.dateMedium(detail.startDate),
                  dueLabel: context.t('dueDate'),
                  dueText: context.dateMedium(detail.dueDate),
                  overdue: detail.isOverdue,
                ),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.clock, label: context.t('estimatedDuration'), value: '${detail.estimatedDuration} ${context.t('hours')}'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Tone.blue.softBg(context.isDark),
                    border: Border.all(color: Tone.blue.border(context.isDark)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(context.t('jobDescription'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Tone.blue.textAccent(context.isDark))),
                      const SizedBox(height: 8),
                      Text(detail.description, style: TextStyle(fontSize: 14, color: Tone.blue.textStrong(context.isDark), height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SectionHeader(
                        icon: AppIcons.package,
                        tone: Tone.purple,
                        title: context.t('equipmentList'),
                        subtitle: '${detail.equipment.length} ${context.t('items')}',
                      ),
                    ),
                    if (completedCount > 0) AppBadge('✓ $completedCount', variant: BadgeVariant.success, small: true),
                    if (completedCount > 0 && pendingCount > 0) const SizedBox(width: 6),
                    if (pendingCount > 0) AppBadge('⏰ $pendingCount', variant: BadgeVariant.danger, small: true),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: detail.equipment.map((Equipment item) {
                    final bool completed = progress.isCompleted(detail.id, item.id);
                    final Tone tone = completed ? Tone.green : Tone.red;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        gradient: tone.soft(context.isDark),
                        borderColor: tone.border(context.isDark),
                        borderWidth: 2,
                        onTap: () => _openEquipment(context, detail, item.id),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ToneIconBox(icon: completed ? AppIcons.checkCircleSolid : AppIcons.clock, tone: tone, size: 48, iconSize: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: Text(item.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary))),
                                      AppBadge(completed ? context.t('completed') : context.t('pending'), variant: completed ? BadgeVariant.success : BadgeVariant.danger, small: true),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(item.code, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                  Text('${context.t('serialNumber')}: ${item.serialNumber}', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                  Text('${context.t('model')}: ${item.model}', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(child: AppButton(label: context.t('cancel'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => Navigator.of(context).maybePop())),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: context.t('startInspection'),
                  fullWidth: true,
                  onPressed: () => _openEquipment(context, detail, detail.equipment.first.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
