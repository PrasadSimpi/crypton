import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../market/domain/entities/coin.dart';
import '../../../market/domain/entities/market_stats.dart';

/// The six figures under the chart, two to a row.
///
/// A [Wrap] rather than a [GridView]: the list is short and fixed, and Wrap
/// lets a tile grow when the system text size does instead of clipping.
class AssetStatGrid extends StatelessWidget {
  const AssetStatGrid({required this.stats, required this.coin, super.key});

  final MarketStats stats;
  final Coin coin;

  @override
  Widget build(BuildContext context) {
    final entries = <({String key, String value, Color? colour})>[
      (
        key: '24h high',
        value: Formatters.money(stats.high24h, decimals: coin.priceDecimals),
        colour: null,
      ),
      (
        key: '24h low',
        value: Formatters.money(stats.low24h, decimals: coin.priceDecimals),
        colour: null,
      ),
      (
        key: 'Market cap',
        value:
            '${Formatters.currencySymbol}'
            '${Formatters.compact(stats.marketCap, decimals: 2)}',
        colour: null,
      ),
      (
        key: '24h volume',
        value:
            '${Formatters.currencySymbol}${Formatters.compact(stats.volume24h)}',
        colour: null,
      ),
      (
        key: '7d change',
        value: Formatters.signedPercent(stats.change7dPercent),
        colour: stats.change7dPercent >= 0
            ? AppColors.up
            : AppColors.downText,
      ),
      (
        key: 'Circ. supply',
        value: Formatters.compact(stats.circulatingSupply, decimals: 2),
        colour: null,
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final tileWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            for (final entry in entries)
              SizedBox(
                width: tileWidth,
                child: _StatTile(
                  label: entry.key,
                  value: entry.value,
                  valueColor: entry.colour,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.sm,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.subtleBold.copyWith(
                fontSize: 10.5,
                color: AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.numeralSmall.copyWith(color: valueColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
