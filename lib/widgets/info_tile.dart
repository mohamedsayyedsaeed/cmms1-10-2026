import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';

/// `flex items-center gap-3 p-3 bg-gray-50 dark:bg-navy rounded-xl` with an icon,
/// a small label and a value. Used all over the detail screens.
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
    this.radius = 12,
    this.padding = 12,
    this.labelGap = 4,
    this.alignTop = true,
    this.valueWeight = FontWeight.w600,
    this.iconSize = 20,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final double radius;
  final double padding;
  final double labelGap;
  final bool alignTop;
  final FontWeight valueWeight;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: context.tileBg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        crossAxisAlignment:
            alignTop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: alignTop ? 2 : 0),
            child: Icon(icon, size: iconSize, color: Tw.gray.shade400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                ),
                SizedBox(height: labelGap),
                valueWidget ??
                    Text(
                      value ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: valueWeight,
                        color: context.textPrimary,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
