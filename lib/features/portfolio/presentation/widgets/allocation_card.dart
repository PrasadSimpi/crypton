import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/portfolio_summary.dart';

/// The stacked allocation bar and its legend.
///
/// Segments are flexed by weight, so they always sum to the full width without
/// any percentage arithmetic in the layout.
class AllocationCard extends StatelessWidget {
  const AllocationCard({required this.portfolio, super.key});

  final PortfolioSummary portfolio;

  @override
  Widget build(BuildContext context) {
    final holdings = portfolio.byValue;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.card,
        AppSpacing.lg,
        AppSpacing.card,
        AppSpacing.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Allocation', style: AppTextStyles.titleSmall),
              const SizedBox(width: AppSpacing.md),
              // One flexible child, not a Spacer plus a Flexible: those two
              // split the free space between them, which clipped this caption
              // long before it actually ran out of room.
              Expanded(
                child: Text(
                  '${portfolio.assetCount} assets - updated just now',
                  style: AppTextStyles.subtleBold.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 12,
            child: Row(
              children: <Widget>[
                for (var i = 0; i < holdings.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 3),
                  Expanded(
                    flex: (portfolio.allocationOf(holdings[i]) * 10)
                        .round()
                        .clamp(1, 1000),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.coinAccent(holdings[i].symbol),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(i == 0 ? 6 : 3),
                          right: Radius.circular(
                            i == holdings.length - 1 ? 6 : 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.tile),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final holding in holdings)
                _LegendItem(
                  symbol: holding.symbol,
                  percent: portfolio.allocationOf(holding),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.symbol, required this.percent});

  final String symbol;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: AppColors.coinAccent(symbol),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(
          '$symbol ${Formatters.percent(percent, decimals: 1)}',
          style: AppTextStyles.numeralTiny.copyWith(color: AppColors.icon),
        ),
      ],
    );
  }
}
