import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/async_view.dart';
import '../../../../shared/widgets/coin_row.dart';
import '../../../../shared/widgets/page_column.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../market/domain/entities/coin.dart';
import '../../../market/presentation/controllers/market_providers.dart';
import '../../../portfolio/domain/entities/portfolio_summary.dart';
import '../../../portfolio/presentation/controllers/portfolio_providers.dart';
import '../widgets/balance_hero_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/quick_actions.dart';

/// Home: balance, 24h move, quick actions, watchlist.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);
    final watchlist = ref.watch(watchlistProvider);
    final session = ref.watch(authControllerProvider).value;
    final timeframe = ref.watch(dashboardTimeframeProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait(<Future<void>>[
          ref.read(portfolioProvider.notifier).refresh(),
          ref.read(watchlistProvider.notifier).refresh(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          bottom: false,
          child: PageColumn(
            children: <Widget>[
              const SizedBox(height: AppSpacing.sm),
              DashboardAppBar(
                name: session?.name ?? 'Guest',
                initial: session?.initial ?? 'G',
                onSearch: () => context.go(AppRoutes.markets),
                onNotifications: () {},
              ),
              const SizedBox(height: AppSpacing.card),
              AsyncView<PortfolioSummary>(
                value: portfolio,
                loadingHeight: 300,
                onRetry: ref.read(portfolioProvider.notifier).refresh,
                builder: (PortfolioSummary data) {
                  // Draws the curve on once, each time fresh data lands.
                  return TweenAnimationBuilder<double>(
                    key: ValueKey<int>(data.holdings.length),
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1100),
                    curve: Curves.easeOutCubic,
                    builder: (BuildContext context, double t, Widget? child) {
                      return BalanceHeroCard(
                        totalValue: data.totalValue,
                        changeAbsolute: data.change24hAbsolute,
                        changePercent: data.change24hPercent,
                        series: data.valueSeries,
                        timeframe: timeframe,
                        chartProgress: t,
                        onTimeframeSelected: ref
                            .read(dashboardTimeframeProvider.notifier)
                            .select,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              QuickActions(onSelected: (_) => context.go(AppRoutes.markets)),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Watchlist',
                actionLabel: 'See all',
                onAction: () => context.go(AppRoutes.markets),
              ),
              const SizedBox(height: AppSpacing.md),
              AsyncView<List<Coin>>(
                value: watchlist,
                onRetry: ref.read(watchlistProvider.notifier).refresh,
                isEmpty: (List<Coin> coins) => coins.isEmpty,
                emptyMessage: 'Your watchlist is empty.',
                builder: (List<Coin> coins) => _Watchlist(
                  coins: coins,
                  portfolio: portfolio.value,
                ),
              ),
              const SizedBox(height: AppSpacing.navReserve),
            ],
          ),
        ),
      ),
    );
  }
}

/// The watchlist itself. Four rows today, so a [Column] is honest; the moment
/// this is user-editable it becomes a `ListView.builder`.
class _Watchlist extends StatelessWidget {
  const _Watchlist({required this.coins, required this.portfolio});

  final List<Coin> coins;
  final PortfolioSummary? portfolio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var i = 0; i < coins.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          CoinRow(
            coin: coins[i],
            subtitle: _subtitleFor(coins[i]),
            onTap: () =>
                context.push(AppRoutes.assetDetail(coins[i].symbol)),
          ),
        ],
      ],
    );
  }

  String _subtitleFor(Coin coin) {
    final holding = portfolio?.holdingOf(coin.symbol);
    if (holding == null) return 'Not held';
    final quantity = Formatters.quantity(
      holding.quantity,
      decimals: holding.quantityDecimals,
    );
    return '$quantity ${coin.symbol} held';
  }
}
