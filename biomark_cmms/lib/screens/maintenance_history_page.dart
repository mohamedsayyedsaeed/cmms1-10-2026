import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import '../core/utils/collection_ext.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';
import '../widgets/screen_header.dart';

/// MaintenanceHistoryPage.tsx.
class MaintenanceHistoryPage extends StatelessWidget {
  const MaintenanceHistoryPage({super.key, required this.assetId});

  final String assetId;

  Color _color(MaintenanceType t) {
    switch (t) {
      case MaintenanceType.preventive:
        return Tw.green.shade500;
      case MaintenanceType.corrective:
        return Tw.blue.shade500;
      case MaintenanceType.calibration:
        return Tw.purple.shade500;
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
    if (asset == null) {
      return DetailScaffold(
        header: ScreenHeader(title: context.t('maintenanceHistory')),
        body: Center(child: Text(context.t('noData'))),
      );
    }

    return DetailScaffold(
      header: ScreenHeader(title: context.t('maintenanceHistory'), subtitle: asset.name),
      body: asset.maintenanceHistory.isEmpty
          ? Center(child: Text(context.t('noData'), style: TextStyle(color: context.textSecondary)))
          : ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
              children: asset.maintenanceHistory.map((MaintenanceRecord r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    padding: CardPadding.md,
                    borderColor: context.borderColor,
                    leftAccent: _color(r.type),
                    onTap: () => context.go('/assets/$assetId/maintenance/${r.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: Text(r.description, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary))),
                            AppBadge(context.t(r.type.name), variant: _variant(r.type), small: true),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Icon(AppIcons.calendar, size: 16, color: Tw.gray.shade400),
                            const SizedBox(width: 6),
                            Text(context.dateShort(r.date), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            const SizedBox(width: 16),
                            Icon(AppIcons.clock, size: 16, color: Tw.gray.shade400),
                            const SizedBox(width: 6),
                            Text('${r.duration} ${context.t('minutes')}', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(AppIcons.user, size: 16, color: Tw.gray.shade400),
                            const SizedBox(width: 6),
                            Text(r.technician, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
