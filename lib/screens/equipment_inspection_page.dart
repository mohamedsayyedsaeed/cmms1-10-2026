import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../data/models.dart';
import '../state/inspection_progress.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/info_tile.dart';
import '../widgets/screen_header.dart';
import '../widgets/tone_boxes.dart';
import '../widgets/toast.dart';

/// EquipmentInspectionPage.tsx: 8-step pass/fail checklist, auto-advances to the
/// next equipment on save.
class EquipmentInspectionPage extends StatefulWidget {
  const EquipmentInspectionPage({
    super.key,
    required this.inspectionId,
    required this.equipmentId,
    required this.equipmentIds,
  });

  final String inspectionId;
  final String equipmentId;

  /// The full ordered equipment list for this inspection (from the query param).
  final List<String> equipmentIds;

  @override
  State<EquipmentInspectionPage> createState() => _EquipmentInspectionPageState();
}

class _EquipmentInspectionPageState extends State<EquipmentInspectionPage> {
  late List<ChecklistItem> _steps;
  final List<String> _photos = <String>[];
  bool _saving = false;

  static const List<String> _stepDescriptions = <String>[
    'Check power supply and connections',
    'Verify display and control panel functionality',
    'Test alarm systems',
    'Inspect breathing circuit for leaks',
    'Check pressure and flow sensors',
    'Verify emergency backup systems',
    'Inspect filters and replace if necessary',
    'Test all safety features',
  ];

  @override
  void initState() {
    super.initState();
    _resetSteps();
  }

  @override
  void didUpdateWidget(EquipmentInspectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.equipmentId != widget.equipmentId) {
      _resetSteps();
      _photos.clear();
    }
  }

  void _resetSteps() {
    _steps = List<ChecklistItem>.generate(
      _stepDescriptions.length,
      (int i) => ChecklistItem('${i + 1}', _stepDescriptions[i]),
    );
  }

  void _save() {
    final int currentIndex = widget.equipmentIds.indexOf(widget.equipmentId);
    final int total = widget.equipmentIds.length;
    setState(() => _saving = true);

    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _saving = false);
      context.read<InspectionProgress>().markCompleted(widget.inspectionId, widget.equipmentId);

      final bool hasNext = currentIndex >= 0 && currentIndex < total - 1;
      showSuccessToast(
        context,
        title: context.tRead('inspectionSaved'),
        subtitle: hasNext ? context.tRead('movingToNext') : null,
      );

      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        final String param = widget.equipmentIds.join(',');
        if (hasNext) {
          context.go('/inspections/${widget.inspectionId}/equipment/${widget.equipmentIds[currentIndex + 1]}?equipment=$param');
        } else {
          context.go('/inspections/${widget.inspectionId}');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = widget.equipmentIds.indexOf(widget.equipmentId);
    final int total = widget.equipmentIds.isEmpty ? 1 : widget.equipmentIds.length;
    final int shownIndex = currentIndex < 0 ? 0 : currentIndex;
    final int completedDevices = shownIndex;
    final int pendingDevices = total - shownIndex - 1;
    final double progress = (shownIndex + 1) / total;
    final int completedSteps = _steps.where((ChecklistItem s) => s.result != null).length;

    // Mock equipment record (a real build would look this up by widget.equipmentId).
    const String name = 'Ventilator';
    const String code = 'VNT-2024-001';
    const String serial = 'SN-VNT-45678';
    const String model = 'Model V300';
    const String location = 'ICU - Room 205';

    return DetailScaffold(
      header: ScreenHeader(
        title: name,
        subtitle: context.t('equipmentInspection'),
        trailing: AppBadge('${shownIndex + 1} ${context.t('of')} $total', variant: BadgeVariant.primary, small: true),
        bottom: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(context.t('inspectionProgress'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                Row(
                  children: <Widget>[
                    if (completedDevices > 0) ...<Widget>[
                      Icon(AppIcons.checkCircleSolid, size: 14, color: Tw.green.shade500),
                      const SizedBox(width: 4),
                      Text('$completedDevices ${context.t('completed')}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Tw.green.shade600)),
                      const SizedBox(width: 12),
                    ],
                    if (pendingDevices > 0) ...<Widget>[
                      Icon(AppIcons.clock, size: 14, color: Tw.red.shade500),
                      const SizedBox(width: 4),
                      Text('$pendingDevices ${context.t('pending')}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Tw.red.shade600)),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ProgressBar(fraction: progress, gradient: kProgressBrand),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
        children: <Widget>[
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(icon: AppIcons.package, tone: Tone.purple, title: context.t('deviceDetails')),
                const SizedBox(height: 16),
                InfoTile(icon: AppIcons.hash, label: context.t('deviceCode'), value: code),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.fileText, label: context.t('serialNumber'), value: serial),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.fileText, label: context.t('model'), value: model),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.mapPin, label: context.t('location'), value: location),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(icon: AppIcons.checkCircle, tone: Tone.blue, title: context.t('inspectionSteps')),
                const SizedBox(height: 16),
                Column(
                  children: List<Widget>.generate(_steps.length, (int i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChecklistStepTile(
                        index: i,
                        item: _steps[i],
                        passLabel: context.t('pass'),
                        failLabel: context.t('fail'),
                        onChanged: (bool result) => setState(() => _steps[i].result = result),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PhotoAttachCard(
            photos: _photos,
            readOnly: false,
            onAdd: () => setState(() => _photos.add(kSamplePhotoUrl)),
            onRemove: (int i) => setState(() => _photos.removeAt(i)),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: _saving
                ? context.t('loading')
                : (currentIndex >= 0 && currentIndex < total - 1) ? context.t('saveAndNext') : context.t('saveInspection'),
            fullWidth: true,
            loading: _saving,
            onPressed: (_saving || completedSteps == 0) ? null : _save,
          ),
        ],
      ),
    );
  }
}
