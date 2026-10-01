import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import 'anim.dart';

/// Pill switch used for the duty status (64x32) and the settings toggles (56x32).
/// The knob uses directional alignment, so it slides correctly in RTL.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeGradient,
    this.width = 56,
    this.height = 32,
    this.knob = 24,
    this.activeGlow,
    this.showActiveDot = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Gradient activeGradient;
  final double width;
  final double height;
  final double knob;
  final Color? activeGlow;
  final bool showActiveDot;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final double inset = (height - knob) / 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        height: height,
        padding: EdgeInsets.all(inset),
        decoration: BoxDecoration(
          gradient: value ? activeGradient : null,
          color: value ? null : (dark ? Tw.gray.shade600 : Tw.gray.shade300),
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: value && activeGlow != null
              ? <BoxShadow>[
                  BoxShadow(
                    color: activeGlow!,
                    blurRadius: 12,
                    spreadRadius: -2,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Container(
            width: knob,
            height: knob,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.op(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: showActiveDot && value
                ? Center(
                    child: Pulse(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Tw.green.shade500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
