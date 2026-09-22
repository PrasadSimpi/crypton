import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_text.dart';

/// Current value against total invested, and the all-time result.
class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({
    required this.currentValue,
    required this.totalInvested,
    required this.profit,
    required this.profitPercent,
    super.key,
  });

  final double currentValue;
  final double totalInvested;
  final double profit;
  final double profitPercent;

  @override
  Widget build(BuildContext context) {
    final isUp = profit >= 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _Metric(
                  label: 'CURRENT VALUE',
                  value: currentValue,
                  style: AppTextStyles.metric,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _Metric(
                  label: 'TOTAL INVESTED',
                  value: totalInvested,
                  style: AppTextStyles.metric.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Divider(color: AppColors.divider),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ALL-TIME PROFIT', style: AppTextStyles.label),
                    const SizedBox(height: AppSpacing.xs + 1),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Formatters.signedMoney(profit),
                        style: AppTextStyles.profit.copyWith(
                          color: isUp ? AppColors.up : AppColors.downText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _ReturnChip(percent: profitPercent),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final double value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.xs + 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: MoneyText(
            value: value,
            style: style,
            fractionStyle: AppTextStyles.metricFraction,
          ),
        ),
      ],
    );
  }
}

/// The percentage return, as a tinted pill with a direction arrow.
class _ReturnChip extends StatelessWidget {
  const _ReturnChip({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final isUp = percent >= 0;
    final colour = isUp ? AppColors.up : AppColors.downText;

    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.tile),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.13),
        borderRadius: AppRadii.pill,
        border: Border.all(color: colour.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 12,
            color: colour,
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            Formatters.percent(percent.abs()),
            style: AppTextStyles.numeral.copyWith(
              fontWeight: FontWeight.w700,
              color: colour,
            ),
          ),
        ],
      ),
    );
  }
}
