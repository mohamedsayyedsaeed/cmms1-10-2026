import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/signature_pad.dart';
import '../core/utils/collection_ext.dart';

/// WorkOrderDetailsPage.tsx.
class WorkOrderDetailsPage extends StatefulWidget {
  const WorkOrderDetailsPage({super.key, required this.id});

  final String id;

  @override
  State<WorkOrderDetailsPage> createState() => _WorkOrderDetailsPageState();
}

class _WorkOrderDetailsPageState extends State<WorkOrderDetailsPage> {
  final SignatureController _signature = SignatureController();

  @override
  void dispose() {
    _signature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WorkOrder? wo = mockWorkOrders.where((WorkOrder w) => w.id == widget.id).firstOrNull;

    if (wo == null) {
      return DetailScaffold(
        header: ScreenHeader(title: widget.id),
        body: const Center(child: Text('Work order not found')),
      );
    }

    final List<(String, String)> steps = <(String, String)>[
      ('Assigned', 'completed'),
      ('In Progress', wo.status == WorkOrderStatus.inProgress
          ? 'active'
          : wo.status == WorkOrderStatus.completed
              ? 'completed'
              : 'pending'),
      ('Completed', wo.status == WorkOrderStatus.completed ? 'completed' : 'pending'),
    ];

    return DetailScaffold(
      header: ScreenHeader(
        title: wo.id,
        subtitle: context.t('workOrderDetails'),
        trailing: AppBadge(context.t(wo.priority.label), variant: wo.priority == WorkOrderPriority.critical ? BadgeVariant.danger : BadgeVariant.warning),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, context.navBottomPad),
        children: <Widget>[
          AppCard(
            borderColor: context.borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Status Timeline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                const SizedBox(height: 16),
                Column(
                  children: steps.map((step) {
                    final String status = step.$2;
                    final Color dotColor = status == 'completed'
                        ? AppColors.accent
                        : status == 'active'
                            ? AppColors.primary
                            : (context.isDark ? Tw.gray.shade700 : Tw.gray.shade200);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: status == 'completed'
                                ? const Icon(Icons.check, size: 18, color: Colors.white)
                                : status == 'active'
                                    ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                                    : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            step.$1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: status == 'pending' ? Tw.gray.shade400 : context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                Text('Asset Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                const SizedBox(height: 12),
                _kv(context, AppIcons.mapPin, 'Location:', wo.location),
                _kv(context, AppIcons.clock, 'Due:', context.dateShort(wo.dueDate)),
                _kv(context, AppIcons.user, 'Assigned:', wo.assignedTo),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
                  child: Text(wo.description, style: TextStyle(fontSize: 13, color: context.textSecondary)),
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
                    Expanded(child: Text('Maintenance Steps', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary))),
                    TextButton.icon(onPressed: () {}, icon: const Icon(AppIcons.plus, size: 16), label: Text(context.t('addStep'))),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: wo.steps.map((MaintenanceStep step) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            step.completed ? Icons.check_box : Icons.check_box_outline_blank,
                            size: 20,
                            color: step.completed ? AppColors.accent : Tw.gray.shade400,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: step.completed ? Tw.gray.shade400 : context.textPrimary,
                                decoration: step.completed ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                Text(context.t('uploadPhoto'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                const SizedBox(height: 12),
                Container(
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.borderColor, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(AppIcons.camera, size: 32, color: Tw.gray.shade400),
                      const SizedBox(height: 8),
                      Text('Tap to add photo', style: TextStyle(fontSize: 13, color: context.textSecondary)),
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
                Text(context.t('signature'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.borderColor, width: 2),
                    color: context.tileBg,
                  ),
                  child: SignaturePad(controller: _signature),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(child: AppButton(label: context.t('clear'), variant: ButtonVariant.outline, size: ButtonSize.sm, fullWidth: true, onPressed: _signature.clear)),
                    const SizedBox(width: 8),
                    Expanded(child: AppButton(label: context.t('save'), size: ButtonSize.sm, fullWidth: true, onPressed: () {})),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(child: AppButton(label: 'Save Draft', variant: ButtonVariant.outline, fullWidth: true, onPressed: () {})),
              const SizedBox(width: 12),
              Expanded(child: AppButton(label: context.t('completeWorkOrder'), fullWidth: true, onPressed: () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16, color: Tw.gray.shade400),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, color: context.textSecondary)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
        ],
      ),
    );
  }
}
