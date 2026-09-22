import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../features/market/domain/entities/coin.dart';
import 'coin_avatar.dart';
import 'delta_label.dart';
import 'sparkline.dart';

/// One asset in a list: monogram, name, a caller-supplied sub-line, an optional
/// sparkline, then price and 24h change.
///
/// Shared by the dashboard watchlist and the Markets tab - they differ only in
/// [subtitle] and whether the sparkline is drawn, so both stay in step.
class CoinRow extends StatelessWidget {
  const CoinRow({
    required this.coin,
    required this.subtitle,
    super.key,
    this.onTap,
    this.showSparkline = true,
    this.height = 62,
  });

  final Coin coin;

  /// Second line: held quantity on the dashboard, market cap on Markets.
  final String subtitle;

  final VoidCallback? onTap;
  final bool showSparkline;
  final double height;

  @override
  Widget build(BuildContext context) {
    final trendColour = coin.isUp ? AppColors.up : AppColors.down;

    return Semantics(
      button: onTap != null,
      label:
          '${coin.name}, ${Formatters.money(coin.price, decimals: coin.priceDecimals)}, '
          '${Formatters.signedPercent(coin.changePercent24h)} today',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.md,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: height),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: <Widget>[
                CoinAvatar(symbol: coin.symbol),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        coin.name,
                        style: AppTextStyles.rowTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: AppTextStyles.subtle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (showSparkline) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  Sparkline(points: coin.sparkline, color: trendColour),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Formatters.money(
                        coin.price,
                        decimals: coin.priceDecimals,
                      ),
                      style: AppTextStyles.numeral,
                    ),
                    const SizedBox(height: 3),
                    DeltaLabel(value: coin.changePercent24h),
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
