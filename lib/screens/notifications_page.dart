import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/layout.dart';

/// NotificationsPage.tsx.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  IconData _icon(NotificationType t) {
    switch (t) {
      case NotificationType.alert:
        return AppIcons.alertCircle;
      case NotificationType.assignment:
        return AppIcons.clipboardList;
      case NotificationType.update:
        return Icons.info_outline;
    }
  }

  Color _iconColor(NotificationType t) {
    switch (t) {
      case NotificationType.alert:
        return Tw.red.shade600;
      case NotificationType.assignment:
        return Tw.blue.shade600;
      case NotificationType.update:
        return Tw.green.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AppNotification> today = mockNotifications.where((AppNotification n) => !n.read).toList();
    final List<AppNotification> earlier = mockNotifications.where((AppNotification n) => n.read).toList();

    return PageList(
      safeTop: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: PageTitle(context.t('notifications'))),
            AppButton(label: context.t('markAllRead'), variant: ButtonVariant.ghost, size: ButtonSize.sm, onPressed: () {}),
          ],
        ),
        if (today.isNotEmpty) _Group(title: 'Today', items: today, dim: false, icon: _icon, color: _iconColor),
        if (earlier.isNotEmpty) _Group(title: 'Earlier', items: earlier, dim: true, icon: _icon, color: _iconColor),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.items,
    required this.dim,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<AppNotification> items;
  final bool dim;
  final IconData Function(NotificationType) icon;
  final Color Function(NotificationType) color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textSecondary)),
        const SizedBox(height: 8),
        Column(
          children: items.map((AppNotification n) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Opacity(
                opacity: dim ? 0.6 : 1,
                child: AppCard(
                  borderColor: !n.read ? AppColors.primary : context.borderColor,
                  borderWidth: !n.read ? 4 : 1,
                  leftAccent: !n.read ? AppColors.primary : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(icon(n.type), size: 20, color: color(n.type)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(n.title, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
                            Text(n.message, style: TextStyle(fontSize: 13, color: context.textSecondary)),
                            const SizedBox(height: 6),
                            Text(
                              dim ? context.dateShort(n.timestamp) : context.timeOf(n.timestamp),
                              style: TextStyle(fontSize: 11, color: context.textSecondary.withAlpha(180)),
                            ),
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
    );
  }
}
