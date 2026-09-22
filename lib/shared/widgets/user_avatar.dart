import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// The amber-tinted initial disc standing in for a profile photo.
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.initial, super.key, this.size = 44});

  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    final large = size >= 56;

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: large ? const Color(0xFF3A3F47) : const Color(0xFF33383F),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: large
                ? const <Color>[Color(0xFF3A2B15), Color(0xFF16181C)]
                : const <Color>[Color(0xFF2A2116), Color(0xFF14161A)],
          ),
        ),
        child: Text(
          initial,
          style: AppTextStyles.numeralLarge.copyWith(
            fontSize: large ? 24 : 16,
            color: AppColors.accent,
          ),
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}
