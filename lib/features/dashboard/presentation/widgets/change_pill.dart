import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

/// The dark pill on the amber hero card: 24h move in money and percent.
class ChangePill extends StatelessWidget {
  const ChangePill({
    required this.absolute,
    required this.percent,
    super.key,
    this.caption = '24h',
  });

  final double absolute;
  final double percent;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final isUp = absolute >= 0;
    final colour = isUp ? AppColors.upSoft : AppColors.downText;
    final numeral = AppTextStyles.numeralTiny.copyWith(
      fontSize: 13,
      color: colour,
    );

    return Semantics(
      label:
          '${Formatters.signedMoney(absolute)}, '
          '${Formatters.signedPercent(percent)} over $caption',
      excludeSemantics: true,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.onAccent,
          borderRadius: AppRadii.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 12,
              color: colour,
            ),
            const SizedBox(width: 7),
            Text(Formatters.signedMoney(absolute), style: numeral),
            Container(
              width: 1,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              color: Colors.white.withValues(alpha: 0.16),
            ),
            Text(Formatters.signedPercent(percent), style: numeral),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              caption,
              style: AppTextStyles.subtleBold.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
