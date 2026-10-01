import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';

/// Green success pill (the prototype's `fixed top-20 ... bg-green-500` toasts).
/// [centered] puts it mid-screen like the Settings "signature saved" message.
void showSuccessToast(
  BuildContext context, {
  required String title,
  String? subtitle,
  bool centered = false,
  Duration duration = const Duration(milliseconds: 2500),
}) {
  final OverlayState overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext ctx) => _ToastView(
      title: title,
      subtitle: subtitle,
      centered: centered,
      duration: duration,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _ToastView extends StatefulWidget {
  const _ToastView({
    required this.title,
    required this.subtitle,
    required this.centered,
    required this.duration,
    required this.onDone,
  });

  final String title;
  final String? subtitle;
  final bool centered;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _run();
  }

  Future<void> _run() async {
    await _c.forward();
    await Future<void>.delayed(widget.duration);
    if (!mounted) return;
    await _c.reverse();
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top + 80;
    final Widget pill = Container(
      constraints: const BoxConstraints(minWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Tw.green.shade500,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.op(0.25),
            blurRadius: 40,
            spreadRadius: -8,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.check_circle, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      color: Colors.white.op(0.9),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return IgnorePointer(
      child: Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: widget.centered ? Alignment.center : Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: widget.centered ? 0 : top),
            child: FadeTransition(
              opacity: _c,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)),
                child: pill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
