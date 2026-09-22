import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';

/// One of the two small P&L tiles: realised and unrealised.
class PnlMiniCard extends StatelessWidget {
  const PnlMiniCard({
    required this.label,
    required this.amount,
    required this.note,
    super.key,
  });

  final String label;
  final double amount;

  /// Sub-line, e.g. `Booked - 12 exits`.
  final String note;

  @override
  Widget build(BuildContext context) {
    final colour = amount >= 0 ? AppColors.up : AppColors.downText;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.tile),
      borderRadius: AppRadii.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: AppTextStyles.tiny),
          const SizedBox(height: AppSpacing.xs + 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Formatters.signedMoney(amount),
              style: AppTextStyles.numeralLarge.copyWith(
                fontSize: 18,
                letterSpacing: -0.5,
                color: colour,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            note,
            style: AppTextStyles.subtle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
