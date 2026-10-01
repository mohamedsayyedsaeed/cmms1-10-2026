import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/icon_btn.dart';
import '../widgets/layout.dart';

/// WorkOrdersPage.tsx.
class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageList(
      safeTop: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: PageTitle(context.t('workOrders'))),
            IconBtn(icon: AppIcons.filter, onPressed: () {}),
          ],
        ),
        AppTextField(hint: context.t('search'), icon: AppIcons.search),
        Column(
          children: spaced(mockWorkOrders.map((WorkOrder wo) {
            return AppCard(
              onTap: () => context.go('/work-orders/${wo.id}'),
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
                            Row(
                              children: <Widget>[
                                Text(
                                  wo.id,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AppBadge(context.t(wo.priority.label), variant: _priority(wo.priority), small: true),
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
                            const SizedBox(height: 2),
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
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Due: ${context.dateShort(wo.dueDate)}',
                          style: TextStyle(fontSize: 12, color: context.textSecondary),
                        ),
                        Text(
                          '${wo.steps.where((MaintenanceStep s) => s.completed).length}/${wo.steps.length} steps',
                          style: TextStyle(fontSize: 12, color: context.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(), 12),
        ),
      ],
    );
  }

  static BadgeVariant _priority(WorkOrderPriority p) {
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
