import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/dialogs.dart';
import '../widgets/info_tile.dart';
import '../widgets/screen_header.dart';
import '../widgets/signature_pad.dart';
import '../widgets/tone_boxes.dart';
import '../widgets/toast.dart';

/// PMDetailPage.tsx: 10-step checklist, signature modal, export/email modal.
class PmDetailPage extends StatefulWidget {
  const PmDetailPage({super.key, required this.id});

  final String id;

  @override
  State<PmDetailPage> createState() => _PmDetailPageState();
}

class _PmDetailPageState extends State<PmDetailPage> {
  static const List<String> _stepDescriptions = <String>[
    'Check and clean air filters',
    'Inspect and test all alarms',
    'Calibrate pressure sensors',
    'Test backup battery system',
    'Lubricate moving parts',
    'Check breathing circuit connections',
    'Verify flow rate accuracy',
    'Test emergency shutdown procedures',
    'Update maintenance log',
    'Perform functional test',
  ];

  late final List<ChecklistItem> _steps = List<ChecklistItem>.generate(
    _stepDescriptions.length,
    (int i) => ChecklistItem('${i + 1}', _stepDescriptions[i]),
  );

  final List<String> _photos = <String>[];
  final SignatureController _signature = SignatureController();
  final TextEditingController _technician = TextEditingController();
  final TextEditingController _email = TextEditingController();

  bool _saving = false;
  bool _completed = false;
  bool _signed = false;
  bool _exporting = false;

  @override
  void dispose() {
    _signature.dispose();
    _technician.dispose();
    _email.dispose();
    super.dispose();
  }

  void _completePm() {
    setState(() => _saving = true);
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _completed = true;
      });
      showSuccessToast(context, title: context.tRead('pmSaved'));
    });
  }

  void _openSignatureModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => StatefulBuilder(builder: (BuildContext ctx, StateSetter setModalState) {
        return AppModal(
          title: context.t('signature'),
          compact: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppTextField(
                label: '${context.t('technician')} ${context.t('deviceName')}',
                hint: 'Enter your name',
                controller: _technician,
                onChanged: (_) => setModalState(() {}),
              ),
              const SizedBox(height: 16),
              Text(context.t('signHere'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: SignaturePad(controller: _signature),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(child: AppButton(label: context.t('clear'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => setModalState(_signature.clear))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: context.t('save'),
                      fullWidth: true,
                      onPressed: _technician.text.trim().isEmpty || _signature.isEmpty
                          ? null
                          : () {
                              setState(() => _signed = true);
                              Navigator.of(ctx).pop();
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void _openExportModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => StatefulBuilder(builder: (BuildContext ctx, StateSetter setModalState) {
        void doExport(VoidCallback afterward) {
          setModalState(() => _exporting = true);
          Future<void>.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            setModalState(() => _exporting = false);
            Navigator.of(ctx).pop();
            afterward();
          });
        }

        return AppModal(
          title: context.t('exportReport'),
          compact: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _exporting ? null : () => doExport(() => showSuccessToast(context, title: 'PDF exported successfully!')),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all(color: context.borderColor, width: 2), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: <Widget>[
                        const SoftIconBox(icon: AppIcons.download, tone: Tone.blue, size: 48, iconSize: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(context.t('exportAsPDF'), style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
                              Text(context.t('downloadPDF'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: context.borderColor, width: 2), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SoftIconBox(icon: AppIcons.mail, tone: Tone.green, size: 48, iconSize: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(context.t('sendByEmail'), style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
                              Text(context.t('emailReport'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppTextField(hint: context.t('enterEmailAddress'), icon: AppIcons.mail, controller: _email, onChanged: (_) => setModalState(() {})),
                    const SizedBox(height: 12),
                    AppButton(
                      label: _exporting ? context.t('sendingEmail') : context.t('sendReport'),
                      fullWidth: true,
                      loading: _exporting,
                      onPressed: _email.text.trim().isEmpty || _exporting
                          ? null
                          : () => doExport(() => showSuccessToast(context, title: 'Report sent to ${_email.text}')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String taskNumber = 'PM-2024-001';
    const String deviceName = 'Ventilator - Model V300';
    const String deviceCode = 'VNT-2024-001';
    const String serial = 'SN-VNT-45678';
    const String model = 'Model V300';
    const String location = 'ICU - Room 205';
    const bool overdue = true;

    final int completedSteps = _steps.where((ChecklistItem s) => s.result != null).length;
    final double progress = completedSteps / _steps.length;

    return DetailScaffold(
      header: ScreenHeader(
        title: taskNumber,
        subtitle: context.t('pmDetails'),
        trailing: overdue ? const AppBadge('Overdue', variant: BadgeVariant.danger, small: true) : null,
        bottom: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(context.t('maintenanceChecklist'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                Text('$completedSteps/${_steps.length} ${context.t('completed')}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),
            ProgressBar(fraction: progress, gradient: LinearGradient(colors: <Color>[Tw.purple.shade500, Tw.purple.shade600])),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
        children: <Widget>[
          if (_completed) ...<Widget>[
            AppCard(
              gradient: Tone.green.soft(context.isDark),
              borderColor: Tone.green.border(context.isDark),
              borderWidth: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const ToneIconBox(icon: AppIcons.checkCircleSolid, tone: Tone.green, size: 48, iconSize: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(context.t('completed'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Tone.green.textStrong(context.isDark))),
                            Text('PM task completed successfully', style: TextStyle(fontSize: 12, color: Tone.green.textMid(context.isDark))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(child: _CompletionAction(icon: AppIcons.penTool, label: context.t('signature'), done: _signed, onTap: _openSignatureModal)),
                      const SizedBox(width: 12),
                      Expanded(child: _CompletionAction(icon: AppIcons.share, label: context.t('export'), done: false, onTap: _openExportModal)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(icon: AppIcons.package, tone: Tone.purple, title: context.t('deviceDetails')),
                const SizedBox(height: 16),
                InfoTile(icon: AppIcons.wrench, label: context.t('deviceName'), value: deviceName),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.hash, label: context.t('deviceCode'), value: deviceCode),
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
                SectionHeader(icon: AppIcons.checkCircle, tone: Tone.blue, title: context.t('pmChecklist')),
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
                        disabled: _completed,
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
            readOnly: _completed,
            onAdd: () => setState(() => _photos.add(kSamplePhotoUrl)),
            onRemove: (int i) => setState(() => _photos.removeAt(i)),
          ),
          if (!_completed) ...<Widget>[
            const SizedBox(height: 16),
            AppButton(
              label: _saving ? context.t('loading') : context.t('completePM'),
              fullWidth: true,
              loading: _saving,
              onPressed: (_saving || completedSteps == 0) ? null : _completePm,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompletionAction extends StatelessWidget {
  const _CompletionAction({required this.icon, required this.label, required this.done, required this.onTap});

  final IconData icon;
  final String label;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: Tone.green.border(context.isDark), width: 2), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: <Widget>[
              SoftIconBox(icon: icon, tone: Tone.green, size: 40, iconSize: 20),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
              if (done) ...<Widget>[
                const SizedBox(height: 4),
                const AppBadge('✓', variant: BadgeVariant.success, small: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
