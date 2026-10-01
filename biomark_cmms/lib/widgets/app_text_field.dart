import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';

/// The prototype's `<Input>`: label above, 2px border, rounded-xl, focus = primary.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.error,
    this.textInputAction,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? error;
  final TextInputAction? textInputAction;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: 2),
      );

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Color idle = dark ? Tw.gray.shade700 : Tw.gray.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: dark ? Tw.gray.shade300 : Tw.gray.shade700,
              ),
            ),
          ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          textInputAction: textInputAction,
          style: TextStyle(fontSize: 16, color: context.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Tw.gray.shade400),
            filled: true,
            fillColor: context.cardBg,
            prefixIcon:
                icon != null ? Icon(icon, size: 20, color: Tw.gray.shade400) : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: const BoxConstraints(minHeight: 44),
            border: _border(error != null ? Tw.red.shade500 : idle),
            enabledBorder: _border(error != null ? Tw.red.shade500 : idle),
            focusedBorder: _border(AppColors.primary),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: TextStyle(
                fontSize: 14,
                color: dark ? Tw.red.shade400 : Tw.red.shade600,
              ),
            ),
          ),
      ],
    );
  }
}
