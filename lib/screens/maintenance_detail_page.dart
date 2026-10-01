import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../core/utils/collection_ext.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/screen_header.dart';
import '../widgets/tone_boxes.dart';

/// MaintenanceDetailPage.tsx: gradient header colored by type, cost breakdown.
class MaintenanceDetailPage extends StatelessWidget {
  const MaintenanceDetailPage({super.key, required this.assetId, required this.maintenanceId});

  final String assetId;
  final String maintenanceId;

  Gradient _headerGradient(MaintenanceType t) {
    switch (t) {
      case MaintenanceType.preventive:
        return LinearGradient(colors: <Color>[Tw.green.shade500, Tw.green.shade600, Tw.green.shade700]);
      case MaintenanceType.corrective:
        return LinearGradient(colors: <Color>[Tw.blue.shade500, Tw.blue.shade600, Tw.blue.shade700]);
      case MaintenanceType.calibration:
        return LinearGradient(colors: <Color>[Tw.purple.shade500, Tw.purple.shade600, Tw.purple.shade700]);
    }
  }

  BadgeVariant _variant(MaintenanceType t) {
    switch (t) {
      case MaintenanceType.preventive:
        return BadgeVariant.success;
      case MaintenanceType.corrective:
        return BadgeVariant.primary;
      case MaintenanceType.calibration:
        return BadgeVariant.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Asset? asset = mockAssets.where((Asset a) => a.id == assetId).firstOrNull;
    final MaintenanceRecord? m = asset?.maintenanceHistory.where((MaintenanceRecord r) => r.id == maintenanceId).firstOrNull;

    if (asset == null || m == null) {
      return DetailScaffold(
        header: ScreenHeader(title: context.t('maintenanceDetails')),
        body: Center(child: Text(context.t('noData'))),
      );
    }

    final bool preventive = m.type == MaintenanceType.preventive;
    final double laborCost = m.duration * 1.5;
    final double partsCost = preventive ? 280 : 570;
    final String notes = m.type == MaintenanceType.preventive
        ? 'Routine preventive maintenance completed successfully. All systems tested and functioning within normal parameters. Filter replaced as scheduled. Next PPM due in 30 days.'
        : m.type == MaintenanceType.corrective
            ? 'Pressure sensor malfunction identified and resolved. Replaced faulty sensor and recalibrated system. Performed full diagnostic test - all parameters within acceptable range. Equipment returned to service.'
            : 'Calibration performed according to manufacturer specifications. All measurements verified against certified standards. Documentation updated. Next calibration due in 6 months.';

    return DetailScaffold(
      header: GradientScreenHeader(
        title: context.t('maintenanceDetails'),
        subtitle: asset.name,
        gradient: _headerGradient(m.type),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
        children: <Widget>[
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Text(m.description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimary))),
                    AppBadge(context.t(m.type.name), variant: _variant(m.type)),
                  ],
                ),
                const SizedBox(height: 12),
                InfoTile(icon: AppIcons.calendar, label: context.t('date'), value: context.dateLong(m.date)),
                const SizedBox(height: 8),
                InfoTile(icon: AppIcons.clock, label: context.t('duration'), value: '${m.duration} ${context.t('minutes')}'),
                const SizedBox(height: 8),
                InfoTile(icon: AppIcons.user, label: context.t('completedBy'), value: m.technician),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(icon: AppIcons.wrench, tone: Tone.blue, title: context.t('description')),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(m.description, style: TextStyle(fontSize: 13, color: context.textSecondary, height: 1.4)),
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
                SectionHeader(icon: AppIcons.wrench, tone: Tone.blue, title: context.t('partsUsed')),
                const SizedBox(height: 12),
                _PartRow(
                  name: preventive ? 'HEPA Filter' : 'Pressure Sensor',
                  partNumber: preventive ? 'Part #: HEPA-V300' : 'Part #: PS-V300-001',
                  price: preventive ? '\$280' : '\$450',
                ),
                if (m.type == MaintenanceType.corrective) ...<Widget>[
                  const SizedBox(height: 8),
                  const _PartRow(name: 'Cable Assembly', partNumber: 'Part #: CA-V300-002', price: '\$120'),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeader(icon: AppIcons.dollar, tone: Tone.green, title: 'Cost Summary'),
                const SizedBox(height: 12),
                _CostRow(label: context.t('laborCost'), value: '\$${laborCost.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _CostRow(label: context.t('partsCost'), value: '\$${partsCost.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.op(context.isDark ? 0.2 : 0.1),
                    border: Border.all(color: AppColors.primary.op(0.2), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(context.t('totalCost'), style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary))),
                      Text(
                        '\$${(laborCost + partsCost).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
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
                SectionHeader(icon: AppIcons.fileText, tone: Tone.orange, title: context.t('notes')),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(notes, style: TextStyle(fontSize: 13, color: context.textSecondary, height: 1.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartRow extends StatelessWidget {
  const _PartRow({required this.name, required this.partNumber, required this.price});

  final String name;
  final String partNumber;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: TextStyle(fontWeight: FontWeight.w500, color: context.textPrimary)),
                Text(partNumber, style: TextStyle(fontSize: 12, color: context.textSecondary)),
              ],
            ),
          ),
          Text(price, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: context.textSecondary))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
        ],
      ),
    );
  }
}
