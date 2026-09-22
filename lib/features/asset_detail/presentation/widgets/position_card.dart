import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../portfolio/domain/entities/holding.dart';

/// The amber-tinted strip showing the user's position in this asset.
class PositionCard extends StatelessWidget {
  const PositionCard({required this.holding, super.key, this.onTap});

  final Holding holding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent.withValues(alpha: 0.07),
      borderRadius: AppRadii.md,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.tile,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.md,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.24),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'YOUR POSITION',
                      style: AppTextStyles.label.copyWith(
                        letterSpacing: 0.9,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${Formatters.quantity(holding.quantity, decimals: holding.quantityDecimals)} '
                      '${holding.symbol} - avg '
                      '${Formatters.money(holding.averageCost, decimals: holding.priceDecimals)}',
                      style: AppTextStyles.numeralMono.copyWith(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    Formatters.money(holding.marketValue),
                    style: AppTextStyles.numeral.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    Formatters.signedPercent(
                      holding.unrealisedPnlPercent,
                      decimals: 1,
                    ),
                    style: AppTextStyles.numeralTiny.copyWith(
                      fontWeight: FontWeight.w700,
                      color: holding.isUp
                          ? AppColors.up
                          : AppColors.downText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
