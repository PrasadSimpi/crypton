import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/coin_avatar.dart';
import '../../domain/entities/holding.dart';

/// A position in the Holdings list: value on the right, profit underneath.
class HoldingRow extends StatelessWidget {
  const HoldingRow({required this.holding, super.key, this.onTap});

  final Holding holding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colour = holding.isUp ? AppColors.up : AppColors.downText;

    return Semantics(
      button: onTap != null,
      label:
          '${holding.name}, worth ${Formatters.money(holding.marketValue)}, '
          '${Formatters.signedPercent(holding.unrealisedPnlPercent, decimals: 1)}',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.md,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: <Widget>[
                CoinAvatar(symbol: holding.symbol),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        holding.name,
                        style: AppTextStyles.rowTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${Formatters.quantity(holding.quantity, decimals: holding.quantityDecimals)}'
                        ' - avg ${Formatters.money(holding.averageCost, decimals: holding.priceDecimals)}',
                        style: AppTextStyles.numeralMono,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Formatters.money(holding.marketValue),
                      style: AppTextStyles.numeral,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${Formatters.signedMoney(holding.unrealisedPnl)}'
                      ' - ${Formatters.percent(holding.unrealisedPnlPercent.abs(), decimals: 1)}',
                      style: AppTextStyles.numeralTiny.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colour,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
