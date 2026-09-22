import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/money_text.dart';
import '../../../../shared/widgets/timeframe_selector.dart';
import '../../../market/domain/entities/timeframe.dart';
import 'change_pill.dart';
import 'portfolio_area_chart.dart';

/// The amber card at the top of the dashboard: total balance, 24h move, the
/// value curve, and the window selector.
class BalanceHeroCard extends StatelessWidget {
  const BalanceHeroCard({
    required this.totalValue,
    required this.changeAbsolute,
    required this.changePercent,
    required this.series,
    required this.timeframe,
    required this.onTimeframeSelected,
    super.key,
    this.chartProgress = 1,
    this.currencyCode = 'USD',
  });

  final double totalValue;
  final double changeAbsolute;
  final double changePercent;

  /// Portfolio value over the window, normalised 0..1.
  final List<double> series;

  final Timeframe timeframe;
  final ValueChanged<Timeframe> onTimeframeSelected;

  /// 0..1 of the curve drawn so far, for the entrance animation.
  final double chartProgress;

  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final label = AppTextStyles.label.copyWith(
      fontSize: 12,
      color: AppColors.onAccent.withValues(alpha: 0.70),
      letterSpacing: 1.2,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: const BoxDecoration(
        color: AppColors.accent,
        borderRadius: AppRadii.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('TOTAL BALANCE', style: label),
              Text(currencyCode, style: label),
            ],
          ),
          const SizedBox(height: AppSpacing.sm - 2),
          Semantics(
            label: 'Total balance ${Formatters.money(totalValue)}',
            excludeSemantics: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: MoneyText(
                value: totalValue,
                style: AppTextStyles.heroBalance,
                fractionStyle: AppTextStyles.heroBalanceFraction,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ChangePill(absolute: changeAbsolute, percent: changePercent),
          const SizedBox(height: AppSpacing.tile),
          PortfolioAreaChart(points: series, progress: chartProgress),
          const SizedBox(height: AppSpacing.md),
          // The chips can overflow a narrow phone once text is scaled up, so
          // the row scrolls rather than clipping.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TimeframeSelector<Timeframe>(
              values: Timeframe.values,
              selected: timeframe,
              labelOf: (Timeframe value) => value.label,
              onSelected: onTimeframeSelected,
            ),
          ),
        ],
      ),
    );
  }
}
