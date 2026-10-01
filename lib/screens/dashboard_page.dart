import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/anim.dart';
import '../widgets/app_avatar.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';
import '../widgets/app_toggle.dart';
import '../widgets/dialogs.dart';
import '../widgets/layout.dart';
import '../widgets/tone_boxes.dart';

/// DashboardPage.tsx.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _InstalledAsset {
  const _InstalledAsset(this.id, this.name, this.location, this.installedDate);
  final String id;
  final String name;
  final String location;
  final DateTime installedDate;
}

class _DashboardPageState extends State<DashboardPage> {
  bool _onDuty = true;

  static final List<_InstalledAsset> _recentAssets = <_InstalledAsset>[
    _InstalledAsset('AST-003', 'Infusion Pump - IP200', 'ICU - Room 205', DateTime(2024, 1, 12)),
    _InstalledAsset('AST-004', 'ECG Machine - ECG500', 'ER - Station 4', DateTime(2024, 1, 10)),
    _InstalledAsset('AST-005', 'Defibrillator - DF300', 'Operating Room 2', DateTime(2024, 1, 8)),
    _InstalledAsset('AST-006', 'Ultrasound - US400', 'Radiology', DateTime(2024, 1, 5)),
  ];

  void _showScanModal() {
    showAppDialog<void>(context, builder: (BuildContext context) => const _NfcScanDialog());
  }

  @override
  Widget build(BuildContext context) {
    final int unread = mockNotifications.where((AppNotification n) => !n.read).length;

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _Header(unread: unread),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, context.navBottomPad),
          child: Column(
            children: spaced(<Widget>[
              _DutyStatusCard(onDuty: _onDuty, onChanged: (bool v) => setState(() => _onDuty = v)),
              _QuickActionsCard(onScan: _showScanModal),
              _ActiveWorkOrders(),
              _IpmCard(),
              const _CriticalAlertCard(),
              const _WarrantyCard(),
              _RecentAssetsCard(assets: _recentAssets),
            ], 24),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.unread});

  final int unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 20, 16, 24),
      decoration: const BoxDecoration(gradient: Gradients.headerBlue),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  const AppAvatar(size: 56),
                  PositionedDirectional(
                    bottom: -2,
                    end: -2,
                    child: Pulse(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${context.t('welcome')}, Ahmed',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Biomedical Engineer',
                      style: TextStyle(fontSize: 14, color: Colors.cyan.shade100),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/notifications'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.op(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.op(0.2)),
                      ),
                      child: const Icon(AppIcons.bell, color: Colors.white),
                    ),
                    if (unread > 0)
                      PositionedDirectional(
                        top: -4,
                        end: -4,
                        child: Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[Colors.red.shade500, Colors.red.shade600],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: spaced(<Widget>[
              _StatChip(icon: AppIcons.alertCircle, value: '12', label: context.t('activeWOs')),
              _StatChip(icon: AppIcons.trendingDown, value: '3', label: context.t('overdue')),
              _StatChip(
                icon: AppIcons.checkCircle,
                value: '8',
                label: context.t('completedToday'),
              ),
              _StatChip(icon: AppIcons.trendingUp, value: '5', label: context.t('ppmDue')),
            ], 8).map((Widget w) => Expanded(child: w)).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.op(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.op(0.2)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: Colors.white.op(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 16, color: Colors.cyan.shade100),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.cyan.shade100, fontSize: 10, height: 1.1),
          ),
        ],
      ),
    );
  }
}

class _DutyStatusCard extends StatelessWidget {
  const _DutyStatusCard({required this.onDuty, required this.onChanged});

  final bool onDuty;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final Tone tone = onDuty ? Tone.green : const Tone(Tw.gray);
    return AppCard(
      borderColor: AppColors.primary.op(0.1),
      child: Row(
        children: <Widget>[
          ToneIconBox(icon: AppIcons.power, tone: tone, size: 48, iconSize: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.t('dutyStatus'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                    children: <InlineSpan>[
                      TextSpan(text: '${context.t('youAreCurrently')} '),
                      TextSpan(
                        text: onDuty ? context.t('onDuty') : context.t('offDuty'),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: onDuty
                              ? (context.isDark ? Tw.green.shade400 : Tw.green.shade600)
                              : context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppToggle(
            value: onDuty,
            onChanged: onChanged,
            width: 64,
            height: 32,
            activeGradient: LinearGradient(colors: <Color>[Tw.green.shade500, Tw.green.shade600]),
            activeGlow: Tw.green.shade500.op(0.3),
            showActiveDot: true,
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: AppColors.primary.op(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AccentTitle('Quick Actions'),
          const SizedBox(height: 16),
          TwoColumnGrid(children: <Widget>[
            _ActionButton(
              icon: AppIcons.plus,
              label: context.t('newWorkOrder'),
              tone: Tone.blue,
              gradient: Gradients.primarySolid,
              glow: AppColors.primary.op(0.3),
              onTap: () {},
            ),
            _ActionButton(
              icon: AppIcons.scan,
              label: context.t('scanAsset'),
              tone: Tone.green,
              gradient: Gradients.accentSolid,
              glow: AppColors.accent.op(0.3),
              onTap: onScan,
            ),
          ]),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.tone,
    required this.gradient,
    required this.glow,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Tone tone;
  final Gradient gradient;
  final Color glow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tone.softBg(context.isDark),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 90),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: <BoxShadow>[BoxShadow(color: glow, blurRadius: 15, spreadRadius: -3)],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveWorkOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<WorkOrder> items = mockWorkOrders.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: AccentTitle(context.t('workOrders'))),
            TextButton(
              onPressed: () => context.go('/work-orders'),
              child: Text('${context.t('viewAll')} →'),
            ),
          ],
        ),
        Column(
          children: spaced(items.map((WorkOrder wo) {
            return AppCard(
              borderColor: context.borderColor,
              onTap: () => context.go('/work-orders/${wo.id}'),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              wo.id,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppBadge(context.t(wo.priority.label), variant: _priorityVariant(wo.priority), small: true),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          wo.assetName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimary,
                          ),
                        ),
                        Text(wo.location, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                      ],
                    ),
                  ),
                  AppBadge(
                    wo.status == WorkOrderStatus.inProgress ? context.t('inProgress') : wo.status.label,
                    variant: wo.status == WorkOrderStatus.inProgress ? BadgeVariant.primary : BadgeVariant.neutral,
                    small: true,
                  ),
                ],
              ),
            );
          }).toList(), 12),
        ),
      ],
    );
  }

  static BadgeVariant _priorityVariant(WorkOrderPriority p) {
    switch (p) {
      case WorkOrderPriority.critical:
        return BadgeVariant.danger;
      case WorkOrderPriority.high:
        return BadgeVariant.warning;
      case WorkOrderPriority.medium:
      case WorkOrderPriority.low:
        return BadgeVariant.neutral;
    }
  }
}

class _IpmCard extends StatelessWidget {
  static const int inspections = 5;
  static const int pm = 8;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: Tw.purple.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(icon: AppIcons.clipboardCheck, tone: Tone.purple, title: context.t('inspectionAndPM')),
          const SizedBox(height: 16),
          TwoColumnGrid(children: <Widget>[
            _IpmTile(
              icon: AppIcons.clipboardCheck,
              tone: Tone.blue,
              count: inspections,
              label: context.t('inspection'),
              sub: '$inspections ${context.t('inspectionTasks')}',
              onTap: () => context.go('/inspections'),
            ),
            _IpmTile(
              icon: AppIcons.wrench,
              tone: Tone.purple,
              count: pm,
              label: context.t('preventiveMaintenance'),
              sub: '$pm ${context.t('pmTasks')}',
              onTap: () => context.go('/preventive-maintenance'),
            ),
          ]),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Tone.purple.softBg(context.isDark),
              border: Border.all(color: Tone.purple.border(context.isDark)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '📋 ${context.t('dueToday')}: ${inspections + pm} tasks',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Tone.purple.textMid(context.isDark)),
            ),
          ),
        ],
      ),
    );
  }
}

class _IpmTile extends StatelessWidget {
  const _IpmTile({
    required this.icon,
    required this.tone,
    required this.count,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  final IconData icon;
  final Tone tone;
  final int count;
  final String label;
  final String sub;
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
          child: Column(
            children: <Widget>[
              ToneIconBox(icon: icon, tone: tone, size: 56, iconSize: 28),
              const SizedBox(height: 12),
              Text(
                '$count',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: tone.iconFg(dark)),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tone.textMid(dark)),
              ),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: tone.textSub(dark)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CriticalAlertCard extends StatelessWidget {
  const _CriticalAlertCard();

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return AppCard(
      gradient: Tone.red.soft(dark),
      borderColor: Tone.red.border(dark),
      borderWidth: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ToneIconBox(icon: AppIcons.alertCircle, tone: Tone.red, size: 40, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Critical Alert',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Tone.red.textStrong(dark)),
                ),
                Text(
                  '3 high-priority work orders require immediate attention',
                  style: TextStyle(fontSize: 14, color: Tone.red.textMid(dark)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarrantyCard extends StatelessWidget {
  const _WarrantyCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: Tw.orange.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(icon: AppIcons.shield, tone: Tone.orange, title: context.t('warrantyStatus')),
          const SizedBox(height: 16),
          Column(
            children: spaced(<Widget>[
              _WarrantyRow(
                icon: AppIcons.clock,
                tone: Tone.yellow,
                title: context.t('expiringIn30Days'),
                subtitle: '7 ${context.t('assetsExpiringSoon')}',
                value: '7',
              ),
              _WarrantyRow(
                icon: AppIcons.alertCircle,
                tone: Tone.orange,
                title: context.t('expiredPast14Days'),
                subtitle: '3 ${context.t('assetsExpired')}',
                value: '3',
              ),
            ], 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Tone.blue.softBg(context.isDark),
              border: Border.all(color: Tone.blue.border(context.isDark)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '💡 ${context.t('reviewWarranties')}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Tone.blue.textMid(context.isDark)),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarrantyRow extends StatelessWidget {
  const _WarrantyRow({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final Tone tone;
  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: tone.soft(dark),
        border: Border.all(color: tone.border(dark)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          ToneIconBox(icon: icon, tone: tone, size: 48, iconSize: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tone.textStrong(dark)),
                ),
                Text(subtitle, style: TextStyle(fontSize: 12, color: tone.textMid(dark))),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: tone.iconFg(dark)),
          ),
        ],
      ),
    );
  }
}

class _RecentAssetsCard extends StatelessWidget {
  const _RecentAssetsCard({required this.assets});

  final List<_InstalledAsset> assets;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return AppCard(
      borderColor: Tw.green.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: SectionHeader(
                  icon: AppIcons.package,
                  tone: Tone.green,
                  title: context.t('recentlyInstalled'),
                  subtitle: context.t('installedLast14Days'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${assets.length}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Tone.green.iconFg(dark)),
                  ),
                  Text(context.t('newAssets'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: spaced(assets.take(3).map((_InstalledAsset a) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/assets/${a.id}'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: Tone.green.soft(dark),
                      border: Border.all(color: Tone.green.border(dark)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        const ToneIconBox(icon: AppIcons.package, tone: Tone.green, size: 40, iconSize: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                a.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.textPrimary,
                                ),
                              ),
                              Text(a.location, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AppBadge(context.t('active'), variant: BadgeVariant.success, small: true),
                            const SizedBox(height: 4),
                            Text(
                              context.dateShort(a.installedDate),
                              style: TextStyle(fontSize: 11, color: context.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(), 8),
          ),
          const SizedBox(height: 12),
          Material(
            color: Tone.green.softBg(dark),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => context.go('/assets'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Tone.green.border(dark)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      context.t('viewNewAssets'),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Tone.green.textAccent(dark)),
                    ),
                    const SizedBox(width: 4),
                    Icon(AppIcons.chevronRight, size: 16, color: Tone.green.textAccent(dark)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NfcScanDialog extends StatefulWidget {
  const _NfcScanDialog();

  @override
  State<_NfcScanDialog> createState() => _NfcScanDialogState();
}

class _NfcScanDialogState extends State<_NfcScanDialog> {
  final bool _scanning = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
        context.go('/assets/AST-001');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      title: context.t('scanningAsset'),
      onClose: () => Navigator.of(context).pop(),
      child: Column(
        children: <Widget>[
          Text(
            context.t('holdPhoneNearTag'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: context.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 20,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (_scanning) Ping(child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 3)))),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(gradient: Gradients.primarySolid, borderRadius: BorderRadius.circular(20)),
                        child: const Icon(AppIcons.radio, color: Colors.white, size: 40),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  child: Container(
                    width: 96,
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[Colors.grey.shade800, Colors.grey.shade900]),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade700, width: 4),
                    ),
                    child: const Icon(AppIcons.smartphone, color: AppColors.primary, size: 48),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _scanning ? context.t('scanningInProgress') : context.t('movePhoneCloser'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimary),
          ),
        ],
      ),
    );
  }
}
