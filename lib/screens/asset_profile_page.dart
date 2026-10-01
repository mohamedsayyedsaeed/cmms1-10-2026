import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../core/utils/collection_ext.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/dialogs.dart';
import '../widgets/icon_btn.dart';
import '../widgets/info_tile.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import '../widgets/tone_boxes.dart';

/// AssetProfilePage.tsx.
class AssetProfilePage extends StatefulWidget {
  const AssetProfilePage({super.key, required this.id});

  final String id;

  @override
  State<AssetProfilePage> createState() => _AssetProfilePageState();
}

class _AssetProfilePageState extends State<AssetProfilePage> {
  bool _generating = false;
  bool _sending = false;
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  BadgeVariant _riskVariant(RiskScore r) {
    switch (r) {
      case RiskScore.high:
        return BadgeVariant.danger;
      case RiskScore.medium:
        return BadgeVariant.warning;
      case RiskScore.low:
        return BadgeVariant.success;
    }
  }

  Color _maintColor(MaintenanceType t) {
    switch (t) {
      case MaintenanceType.preventive:
        return Tw.green.shade500;
      case MaintenanceType.corrective:
        return Tw.blue.shade500;
      case MaintenanceType.calibration:
        return Tw.purple.shade500;
    }
  }

  BadgeVariant _maintVariant(MaintenanceType t) {
    switch (t) {
      case MaintenanceType.preventive:
        return BadgeVariant.success;
      case MaintenanceType.corrective:
        return BadgeVariant.primary;
      case MaintenanceType.calibration:
        return BadgeVariant.purple;
    }
  }

  void _exportPdf() {
    Navigator.of(context).pop();
    setState(() => _generating = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _generating = false);
      showSuccessToast(context, title: context.tRead('reportGenerated'));
    });
  }

  void _sendEmail() {
    if (_email.text.isEmpty) return;
    setState(() => _sending = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _sending = false);
      Navigator.of(context).pop();
      _email.clear();
      showSuccessToast(context, title: context.tRead('reportSent'));
    });
  }

  void _openExportModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('shareReport'),
        child: Column(
          children: <Widget>[
            _ExportOption(
              icon: AppIcons.download,
              tone: Tone.blue,
              title: context.t('exportAsPDF'),
              subtitle: _generating ? context.t('generatingReport') : context.t('downloadPDF'),
              onTap: _exportPdf,
            ),
            const SizedBox(height: 12),
            _ExportOption(
              icon: AppIcons.mail,
              tone: Tone.green,
              title: context.t('sendByEmail'),
              subtitle: context.t('emailReport'),
              onTap: () {
                Navigator.of(ctx).pop();
                _openEmailModal();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openEmailModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => StatefulBuilder(builder: (BuildContext ctx, StateSetter setModalState) {
        return AppModal(
          title: context.t('emailReport'),
          icon: AppIcons.mail,
          tone: Tone.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppTextField(
                label: context.t('enterEmailAddress'),
                hint: context.t('emailPlaceholder'),
                icon: AppIcons.mail,
                controller: _email,
                onChanged: (_) => setModalState(() {}),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Tone.blue.softBg(context.isDark),
                  border: Border.all(color: Tone.blue.border(context.isDark)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '📄 ${context.t('deviceReport')}',
                  style: TextStyle(fontSize: 12, color: Tone.blue.textMid(context.isDark)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(child: AppButton(label: context.t('cancel'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => Navigator.of(ctx).pop())),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: _sending ? context.t('sendingEmail') : context.t('sendReport'),
                      fullWidth: true,
                      loading: _sending,
                      onPressed: _email.text.isEmpty || _sending ? null : _sendEmail,
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

  @override
  Widget build(BuildContext context) {
    final Asset? asset = mockAssets.where((Asset a) => a.id == widget.id).firstOrNull;
    if (asset == null) {
      return DetailScaffold(header: ScreenHeader(title: widget.id), body: const Center(child: Text('Device not found')));
    }

    final List<(String, String)> docs = <(String, String)>[
      ('User Manual', 'PDF • 2.4 MB'),
      ('Service Manual', 'PDF • 5.8 MB'),
      ('Safety Guidelines', 'PDF • 1.2 MB'),
      ('Calibration Certificate', 'PDF • 890 KB'),
    ];

    return DetailScaffold(
      header: ScreenHeader(
        title: asset.name,
        subtitle: context.t('assetProfile'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconBtn(icon: AppIcons.share, onPressed: _openExportModal, background: AppColors.primary, color: Colors.white),
            const SizedBox(width: 8),
            IconBtn(icon: AppIcons.qrCode, onPressed: () {}),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
        children: <Widget>[
          AppCard(
            padding: CardPadding.none,
            borderColor: context.borderColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    const SafeNetworkImage(kSampleDevicePhotoUrl),
                    PositionedDirectional(
                      top: 12,
                      end: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black.op(0.5), borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(AppIcons.image, size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Device Photo', style: TextStyle(fontSize: 11, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(asset.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimary)),
                          Text(asset.model, style: TextStyle(fontSize: 13, color: context.textSecondary)),
                        ],
                      ),
                    ),
                    AppBadge('${asset.riskScore.label} risk', variant: _riskVariant(asset.riskScore)),
                  ],
                ),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.shield, label: 'Serial Number', value: asset.serialNumber),
                const SizedBox(height: 8),
                InfoTile(icon: AppIcons.mapPin, label: 'Location', value: asset.location),
                const SizedBox(height: 8),
                InfoTile(icon: AppIcons.calendar, label: 'Next PPM', value: context.dateShort(asset.nextPPM)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeader(icon: AppIcons.fileCheck, tone: Tone.blue, title: 'Service Contract'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Contract Type', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            Text('Full Maintenance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                          ],
                        ),
                      ),
                      const AppBadge('Active', variant: BadgeVariant.success, small: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const InfoTile(icon: AppIcons.wrench, label: 'Provider', value: 'MedTech Services Inc.'),
                const SizedBox(height: 12),
                const Row(
                  children: <Widget>[
                    const Expanded(child: const InfoTile(icon: AppIcons.calendar, label: 'Start Date', value: 'Jan 15, 2024', iconSize: 0)),
                    SizedBox(width: 12),
                    const Expanded(child: const InfoTile(icon: AppIcons.calendar, label: 'End Date', value: 'Jan 14, 2025', iconSize: 0)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Tone.blue.softBg(context.isDark),
                    border: Border.all(color: Tone.blue.border(context.isDark)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Contract expires in 6 months', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Tone.blue.textMid(context.isDark))),
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
                const SectionHeader(icon: AppIcons.fileText, tone: Tone.orange, title: 'Technical Documents'),
                const SizedBox(height: 16),
                Column(
                  children: docs.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: context.tileBg,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: <Widget>[
                                const SoftIconBox(icon: AppIcons.fileText, tone: Tone.red, size: 40, iconSize: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(doc.$1, style: TextStyle(fontWeight: FontWeight.w500, color: context.textPrimary)),
                                      Text(doc.$2, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                    ],
                                  ),
                                ),
                                Icon(AppIcons.chevronRight, color: Tw.gray.shade400),
                              ],
                            ),
                          ),
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
              Expanded(child: AppButton(label: 'Schedule PPM', fullWidth: true, onPressed: () {})),
              const SizedBox(width: 12),
              Expanded(child: AppButton(label: 'Create WO', variant: ButtonVariant.secondary, fullWidth: true, onPressed: () {})),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text(context.t('maintenanceHistory'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary))),
                    TextButton.icon(
                      onPressed: () => context.go('/assets/${widget.id}/maintenance'),
                      icon: const Icon(AppIcons.chevronRight, size: 16),
                      label: Text(context.t('viewAll')),
                    ),
                  ],
                ),
                Column(
                  children: asset.maintenanceHistory.take(3).map((MaintenanceRecord r) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.go('/assets/${widget.id}/maintenance/${r.id}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(width: 4, height: 48, color: _maintColor(r.type), margin: const EdgeInsetsDirectional.only(end: 8)),
                              const ToneIconBox(icon: AppIcons.calendar, tone: Tone.blue, size: 48, iconSize: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(child: Text(r.description, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimary))),
                                        AppBadge(context.t(r.type.name), variant: _maintVariant(r.type), small: true),
                                      ],
                                    ),
                                    Text('${context.dateShort(r.date)} • ${r.technician} • ${r.duration}min', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  const _ExportOption({required this.icon, required this.tone, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final Tone tone;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: tone.soft(dark),
            border: Border.all(color: tone.border(dark), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: <Widget>[
              ToneIconBox(icon: icon, tone: tone, size: 48, iconSize: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                  ],
                ),
              ),
              Icon(AppIcons.chevronRight, color: Tw.gray.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
