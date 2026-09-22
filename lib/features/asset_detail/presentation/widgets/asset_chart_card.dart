import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../market/domain/entities/candle.dart';
import 'candle_chart.dart';
import 'volume_chart.dart';

/// The chart panel: candles, price axis, live-price tag, volume, date axis.
class AssetChartCard extends StatelessWidget {
  const AssetChartCard({
    required this.candles,
    super.key,
    this.chartHeight = 168,
    this.progress = 1,
    this.priceDecimals = 2,
  });

  final List<Candle> candles;
  final double chartHeight;
  final double progress;
  final int priceDecimals;

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) return const SizedBox.shrink();

    final scale = CandleScale.of(candles);
    final lastClose = candles.last.close;
    final dates = _axisDates(candles.length);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: chartHeight,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CandleChart(
                    candles: candles,
                    height: chartHeight,
                    progress: progress,
                  ),
                ),
                // Axis ticks ride their own gridlines, computed from the same
                // scale the painter uses.
                _AxisTick(
                  top: CandleScale.gridFractions[0] * chartHeight,
                  label: Formatters.compact(scale.high, decimals: 1),
                ),
                _AxisTick(
                  top: CandleScale.gridFractions[1] * chartHeight,
                  label: Formatters.compact(scale.mid, decimals: 1),
                ),
                _AxisTick(
                  top: CandleScale.gridFractions[2] * chartHeight,
                  label: Formatters.compact(scale.low, decimals: 1),
                ),
                Positioned(
                  right: 0,
                  top: (scale.fractionFor(lastClose) * chartHeight - 10).clamp(
                    0.0,
                    chartHeight - 20,
                  ),
                  child: _PriceTag(
                    label: Formatters.money(
                      lastClose,
                      decimals: priceDecimals,
                      withSymbol: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          VolumeChart(candles: candles, progress: progress),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              for (final date in dates)
                Text(Formatters.dayMonth(date), style: AppTextStyles.axis),
            ],
          ),
        ],
      ),
    );
  }

  /// Five evenly spaced tick dates, the last of them today - the bars are
  /// daily, so the axis is simply the last [count] days.
  static List<DateTime> _axisDates(int count) {
    final today = DateTime.now();
    final first = today.subtract(Duration(days: count - 1));
    return <DateTime>[
      for (var i = 0; i < 5; i++)
        first.add(Duration(days: ((count - 1) * i / 4).round())),
    ];
  }
}

class _AxisTick extends StatelessWidget {
  const _AxisTick({required this.top, required this.label});

  final double top;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: (top - 7).clamp(0.0, double.infinity),
      child: ColoredBox(
        color: AppColors.surface.withValues(alpha: 0.85),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(label, style: AppTextStyles.axis),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppTextStyles.priceTag),
    );
  }
}
