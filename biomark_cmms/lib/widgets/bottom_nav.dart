import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import 'anim.dart';

class _NavItem {
  const _NavItem(this.icon, this.label, this.path);

  final IconData icon;
  final String label;

  /// null = the "More" button, which opens the drawer.
  final String? path;
}

/// Floating glassmorphic bottom navigation (BottomNav.tsx).
class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.location, required this.onMenuTap});

  final String location;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final List<_NavItem> items = <_NavItem>[
      _NavItem(AppIcons.home, context.t('dashboard'), '/dashboard'),
      _NavItem(AppIcons.clipboardList, context.t('workOrders'), '/work-orders'),
      _NavItem(AppIcons.package, context.t('assets'), '/assets'),
      const _NavItem(AppIcons.menu, 'More', null),
    ];

    final BorderRadius br = BorderRadius.circular(16);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: br,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.op(0.25),
                  blurRadius: 50,
                  spreadRadius: -12,
                  offset: const Offset(0, 25),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: br,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: dark
                      ? AppColors.navyLight.op(0.8)
                      : Colors.white.op(0.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // top glow line
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.transparent,
                              Tw.cyan.shade400.op(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: items.map((_NavItem item) {
                            final bool active =
                                item.path != null && location == item.path;
                            return _NavButton(
                              item: item,
                              active: active,
                              onTap: () {
                                if (item.path == null) {
                                  onMenuTap();
                                } else {
                                  context.go(item.path!);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Color labelColor = active
        ? (dark ? Colors.white : AppColors.primary)
        : (dark ? Tw.gray.shade400 : Tw.gray.shade600);

    return AnimatedScale(
      scale: active ? 1.05 : 1,
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(minWidth: 60, minHeight: 52),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: active
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            AppColors.primary.op(0.10),
                            AppColors.primary.op(0.05),
                          ],
                        ),
                      )
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: active
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              )
                            : null,
                        color: active ? null : context.chipBg,
                        boxShadow: active
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.primary.op(0.3),
                                  blurRadius: 15,
                                  spreadRadius: -3,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: active ? Colors.white : labelColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (active)
                Positioned(
                  top: -2,
                  child: Pulse(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.primary.op(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
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
