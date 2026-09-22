import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A hairline rule with a centred all-caps label.
class OrDivider extends StatelessWidget {
  const OrDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.tile),
          child: Text(
            label,
            style: AppTextStyles.subtleBold.copyWith(
              letterSpacing: 1.2,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
