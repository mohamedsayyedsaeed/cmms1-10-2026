import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../state/app_state.dart';
import 'app_avatar.dart';
import 'anim.dart';

/// The side menu opened by the bottom nav's "More" button (Drawer.tsx).
/// Flutter's Drawer opens from the leading edge, so it lands on the right in Arabic.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState app = context.watch<AppState>();
    final bool dark = context.isDark;
    final double width = math.min(320, MediaQuery.sizeOf(context).width * 0.85);

    final List<(IconData, String, String)> items = <(IconData, String, String)>[
      (AppIcons.home, context.t('dashboard'), '/dashboard'),
      (AppIcons.clipboardList, context.t('workOrders'), '/work-orders'),
      (AppIcons.package, context.t('assets'), '/assets'),
      (AppIcons.wrench, context.t('spareParts'), '/spare-parts'),
      (AppIcons.fileText, context.t('reports'), '/reports'),
      (AppIcons.bell, context.t('notifications'), '/notifications'),
      (AppIcons.settings, context.t('settings'), '/settings'),
    ];

    void navigate(String path) {
      Navigator.of(context).pop(); // close the drawer
      context.go(path);
    }

    return Drawer(
      width: width,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: <Widget>[
          // ---- gradient header ----
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.paddingOf(context).top + 24,
              24,
              32,
            ),
            decoration: const BoxDecoration(gradient: Gradients.headerBlue),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: <Widget>[
                      Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          const AppAvatar(size: 64),
                          PositionedDirectional(
                            bottom: -4,
                            end: -4,
                            child: Pulse(
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Ahmed Hassan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Biomedical Engineer',
                              style: TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: -8,
                  end: -8,
                  child: Row(
                    children: <Widget>[
                      _HeaderIcon(
                        icon: AppIcons.globe,
                        tooltip: app.isArabic ? 'English' : 'العربية',
                        onTap: app.toggleLanguage,
                      ),
                      const SizedBox(width: 8),
                      _HeaderIcon(
                        icon: dark ? AppIcons.sun : AppIcons.moon,
                        tooltip: dark ? 'Light Mode' : 'Dark Mode',
                        onTap: app.toggleTheme,
                      ),
                      const SizedBox(width: 8),
                      _HeaderIcon(
                        icon: AppIcons.x,
                        tooltip: context.t('close'),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---- menu ----
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                for (final (IconData, String, String) it in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _MenuTile(
                      icon: it.$1,
                      label: it.$2,
                      onTap: () => navigate(it.$3),
                    ),
                  ),
              ],
            ),
          ),

          // ---- logout ----
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: dark ? AppColors.navy : Tw.gray.shade50,
              border: Border(top: BorderSide(color: context.borderColor)),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Tw.red.shade500, Tw.red.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.op(0.15),
                    blurRadius: 15,
                    spreadRadius: -3,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/login');
                  },
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 52),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.op(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(AppIcons.logOut, size: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          context.t('logout'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.op(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.chipBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: context.isDark ? Tw.gray.shade300 : Tw.gray.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.isDark ? Tw.gray.shade300 : Tw.gray.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
