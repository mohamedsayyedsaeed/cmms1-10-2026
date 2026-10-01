import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import 'anim.dart';
import 'tone_boxes.dart';

/// Shows a modal with the prototype's dimmed backdrop (`bg-black/60`).
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.op(0.6),
    builder: builder,
  );
}

/// Shows a panel that slides down from the top edge (the Assets filter sheet).
Future<T?> showTopSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'close',
    barrierColor: Colors.black.op(0.6),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext ctx, Animation<double> a, Animation<double> b) {
      return Align(
        alignment: Alignment.topCenter,
        child: Material(
          type: MaterialType.transparency,
          child: builder(ctx),
        ),
      );
    },
    transitionBuilder: (
      BuildContext ctx,
      Animation<double> anim,
      Animation<double> secondary,
      Widget child,
    ) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}

/// Centered rounded modal card (`max-w-md rounded-3xl p-6`) with the standard
/// icon + title + close header. Pass [compact] for the smaller PM-screen style.
class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.tone,
    this.onClose,
    this.compact = false,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final Tone? tone;
  final VoidCallback? onClose;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final VoidCallback close = onClose ?? () => Navigator.of(context).pop();

    final Widget header = compact
        ? Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
              ),
              InkResponse(
                onTap: close,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: dark ? Tw.gray.shade800 : Tw.gray.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 20, color: context.textSecondary),
                ),
              ),
            ],
          )
        : Row(
            children: <Widget>[
              if (icon != null && tone != null) ...<Widget>[
                SoftIconBox(icon: icon!, tone: tone, size: 48, iconSize: 24, radius: 16),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: close,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.close, size: 24, color: context.textSecondary),
                ),
              ),
            ],
          );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        child: ScaleIn(
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(compact ? 16 : 24),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.op(0.25),
                  blurRadius: 50,
                  spreadRadius: -12,
                  offset: const Offset(0, 25),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  SizedBox(height: compact ? 16 : 24),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
