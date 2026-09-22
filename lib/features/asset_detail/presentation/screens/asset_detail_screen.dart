import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/async_view.dart';
import '../../../../shared/widgets/coin_avatar.dart';
import '../../../../shared/widgets/money_text.dart';
import '../../../../shared/widgets/page_column.dart';
import '../../../../shared/widgets/timeframe_selector.dart';
import '../../../market/domain/entities/timeframe.dart';
import '../../../market/presentation/controllers/market_providers.dart';
import '../../../portfolio/presentation/controllers/portfolio_providers.dart';
import '../widgets/asset_chart_card.dart';
import '../widgets/asset_stat_grid.dart';
import '../widgets/position_card.dart';

/// One asset in full: price, candles, market stats and the user's position.
///
/// Pushed over the shell on the root navigator, so the floating nav is replaced
/// by the Buy/Sell bar rather than sitting on top of it.
class AssetDetailScreen extends ConsumerWidget {
  const AssetDetailScreen({required this.symbol, super.key});

  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(assetDetailProvider(symbol));
    final holding = ref.watch(holdingProvider(symbol));
    final timeframe = ref.watch(candleTimeframeProvider);
    final isWatched = ref.watch(watchedSymbolsProvider).contains(
      symbol.toUpperCase(),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: PageColumn(
                children: <Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: <Widget>[
                      AppIconButton(
                        icon: Icons.chevron_left_rounded,
                        semanticLabel: 'Back',
                        onPressed: () => _pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: _PairButton(symbol: symbol.toUpperCase()),
                        ),
                      ),
                      AppIconButton(
                        icon: isWatched
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        semanticLabel: isWatched
                            ? 'Remove from watchlist'
                            : 'Add to watchlist',
                        foregroundColor: AppColors.accent,
                        onPressed: () => ref
                            .read(watchedSymbolsProvider.notifier)
                            .toggle(symbol),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AsyncView<AssetDetailView>(
                    value: detail,
                    loadingHeight: 460,
                    onRetry: () async =>
                        ref.invalidate(assetDetailProvider(symbol)),
                    builder: (AssetDetailView data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _PriceHeader(
                            price: data.coin.price,
                            changeAbsolute: data.coin.changeAbsolute24h,
                            changePercent: data.coin.changePercent24h,
                            priceDecimals: data.coin.priceDecimals,
                            candleLabel: timeframe.label,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TimeframeSelector<CandleTimeframe>(
                            values: CandleTimeframe.values,
                            selected: timeframe,
                            variant: TimeframeSelectorVariant.grid,
                            labelOf: (CandleTimeframe value) => value.label,
                            onSelected: ref
                                .read(candleTimeframeProvider.notifier)
                                .select,
                          ),
                          const SizedBox(height: AppSpacing.tile),
                          // Re-keyed on the window so switching timeframes
                          // redraws the series rather than snapping.
                          TweenAnimationBuilder<double>(
                            key: ValueKey<String>('$symbol-${timeframe.name}'),
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.easeOutCubic,
                            builder:
                                (
                                  BuildContext context,
                                  double t,
                                  Widget? child,
                                ) => AssetChartCard(
                                  candles: data.candles,
                                  progress: t,
                                  priceDecimals: data.coin.priceDecimals,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.tile),
                          AssetStatGrid(stats: data.stats, coin: data.coin),
                          if (holding != null) ...<Widget>[
                            const SizedBox(height: AppSpacing.md),
                            PositionCard(
                              holding: holding,
                              onTap: () => context.go(AppRoutes.portfolio),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.actionBarReserve),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _ActionBar(symbol: symbol.toUpperCase()),
          ),
        ],
      ),
    );
  }

  /// Falls back to Home when this screen was opened directly by URL and there
  /// is nothing to pop back to.
  static void _pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }
}

/// Price, 24h move, and which candle interval is showing.
class _PriceHeader extends StatelessWidget {
  const _PriceHeader({
    required this.price,
    required this.changeAbsolute,
    required this.changePercent,
    required this.priceDecimals,
    required this.candleLabel,
  });

  final double price;
  final double changeAbsolute;
  final double changePercent;
  final int priceDecimals;
  final String candleLabel;

  @override
  Widget build(BuildContext context) {
    final isUp = changePercent >= 0;
    final colour = isUp ? AppColors.up : AppColors.downText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: MoneyText(
                  value: price,
                  decimals: priceDecimals,
                  style: AppTextStyles.price,
                  fractionStyle: AppTextStyles.priceFraction,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  Icon(
                    isUp
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 12,
                    color: colour,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      '${Formatters.signedMoney(changeAbsolute, decimals: priceDecimals)} '
                      '${Formatters.signedPercent(changePercent)}',
                      style: AppTextStyles.numeralTiny.copyWith(
                        fontSize: 13,
                        color: colour,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('past 24h', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'CANDLES',
              style: AppTextStyles.eyebrow.copyWith(fontSize: 10),
            ),
            const SizedBox(height: AppSpacing.xs + 2),
            Text(
              candleLabel,
              style: AppTextStyles.numeralSmall.copyWith(
                fontSize: 12,
                color: AppColors.icon,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The pair selector in the top bar. Opens nothing yet - there is one quote
/// currency in this build - but it is the affordance the design calls for.
class _PairButton extends StatelessWidget {
  const _PairButton({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$symbol against ${Formatters.currencySymbol}, change pair',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surfaceField,
        borderRadius: AppRadii.pill,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Container(
            height: AppSpacing.minTapTarget,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.tile),
            decoration: BoxDecoration(
              borderRadius: AppRadii.pill,
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CoinAvatar(symbol: symbol, size: 24),
                const SizedBox(width: AppSpacing.sm + 1),
                Text('$symbol / USD', style: AppTextStyles.numeral),
                const SizedBox(width: AppSpacing.xs + 1),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The pinned Buy/Sell bar that replaces the nav pill on this screen.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: Color(0xFF1A1D22))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(label: 'Buy $symbol', onPressed: () {}),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Sell',
                      variant: AppButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
