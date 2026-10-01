import 'package:flutter/material.dart';

import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';

/// Circular avatar. Sizes from the prototype: sm 32, md 40, lg 64.
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.size = 40, this.image});

  final double size;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: dark ? Tw.gray.shade700 : Tw.gray.shade200,
        alignment: Alignment.center,
        child: image != null
            ? Image(image: image!, width: size, height: size, fit: BoxFit.cover)
            : Icon(
                Icons.person_outline,
                size: size / 2,
                color: dark ? Tw.gray.shade400 : Tw.gray.shade500,
              ),
      ),
    );
  }
}
