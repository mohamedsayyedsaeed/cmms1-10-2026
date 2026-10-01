import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/services.dart';

import '../core/theme/context_ext.dart';
import 'app_drawer.dart';
import 'backgrounds.dart';
import 'bottom_nav.dart';

/// AppShell.tsx: shared background + floating bottom nav + side drawer around every
/// screen except splash and login. The nav slides away while scrolling down
/// (the prototype's useScrollDirection hook) and returns on scroll up.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _navHidden = false;

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always show the nav when landing on a new screen.
    if (oldWidget.location != widget.location) _navHidden = false;
  }

  bool _onScroll(UserScrollNotification n) {
    if (n.depth != 0) return false;
    if (n.direction == ScrollDirection.reverse && !_navHidden) {
      setState(() => _navHidden = true);
    } else if (n.direction == ScrollDirection.forward && _navHidden) {
      setState(() => _navHidden = false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.black.op(0.6),
        drawer: const AppDrawer(),
        body: Stack(
          children: <Widget>[
            const Positioned.fill(child: IgnorePointer(child: AppBackground())),
            NotificationListener<UserScrollNotification>(
              onNotification: _onScroll,
              child: widget.child,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: _navHidden,
                child: AnimatedSlide(
                  offset: _navHidden ? const Offset(0, 1.2) : Offset.zero,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: BottomNav(
                    location: widget.location,
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
