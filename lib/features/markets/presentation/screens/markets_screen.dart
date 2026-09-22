import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/async_view.dart';
import '../../../../shared/widgets/coin_row.dart';
import '../../../../shared/widgets/page_column.dart';
import '../../../../shared/widgets/timeframe_selector.dart';
import '../../../market/domain/entities/coin.dart';
import '../../../market/presentation/controllers/market_providers.dart';

/// How the markets list is ordered.
enum MarketSort {
  marketCap('Market cap'),
  gainers('Gainers'),
  losers('Losers');

  const MarketSort(this.label);

  final String label;
}

/// The Markets tab.
///
/// Not in the six reference screens - it is built entirely from components
/// those screens established, so the fourth nav destination is a real screen
/// rather than a dead tab. Noted in the Ledger as an inferred screen.
class MarketsScreen extends ConsumerStatefulWidget {
  const MarketsScreen({super.key});

  @override
  ConsumerState<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends ConsumerState<MarketsScreen> {
  final TextEditingController _query = TextEditingController();
  MarketSort _sort = MarketSort.marketCap;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Filtering and sorting are list operations, not build-method work, so they
  /// happen here and hand the widget a finished list.
  List<Coin> _visible(List<Coin> coins) {
    final needle = _query.text.trim().toLowerCase();
    final filtered = needle.isEmpty
        ? List<Coin>.of(coins)
        : coins
              .where(
                (Coin coin) =>
                    coin.name.toLowerCase().contains(needle) ||
                    coin.symbol.toLowerCase().contains(needle),
              )
              .toList();

    switch (_sort) {
      case MarketSort.marketCap:
        filtered.sort((Coin a, Coin b) => b.marketCap.compareTo(a.marketCap));
      case MarketSort.gainers:
        filtered.sort(
          (Coin a, Coin b) =>
              b.changePercent24h.compareTo(a.changePercent24h),
        );
      case MarketSort.losers:
        filtered.sort(
          (Coin a, Coin b) =>
              a.changePercent24h.compareTo(b.changePercent24h),
        );
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final coins = ref.watch(watchlistProvider);

    return RefreshIndicator(
      onRefresh: ref.read(watchlistProvider.notifier).refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          bottom: false,
          child: PageColumn(
            children: <Widget>[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: AppSpacing.minTapTarget,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Markets', style: AppTextStyles.titleLarge),
                ),
              ),
              const SizedBox(height: AppSpacing.tile),
              _SearchField(
                controller: _query,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              TimeframeSelector<MarketSort>(
                values: MarketSort.values,
                selected: _sort,
                variant: TimeframeSelectorVariant.grid,
                labelOf: (MarketSort value) => value.label,
                onSelected: (MarketSort value) =>
                    setState(() => _sort = value),
              ),
              const SizedBox(height: AppSpacing.tile),
              AsyncView<List<Coin>>(
                value: coins,
                onRetry: ref.read(watchlistProvider.notifier).refresh,
                isEmpty: (List<Coin> all) => _visible(all).isEmpty,
                emptyMessage: 'No assets match that search.',
                builder: (List<Coin> all) {
                  final visible = _visible(all);
                  return Column(
                    children: <Widget>[
                      for (var i = 0; i < visible.length; i++) ...<Widget>[
                        if (i > 0) const SizedBox(height: AppSpacing.sm),
                        CoinRow(
                          coin: visible[i],
                          subtitle:
                              'Cap ${Formatters.compact(visible[i].marketCap, decimals: 2)} '
                              '- Vol ${Formatters.compact(visible[i].volume24h)}',
                          onTap: () => context.push(
                            AppRoutes.assetDetail(visible[i].symbol),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.navReserve),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.body.copyWith(
        color: AppColors.textPrimary,
        fontSize: 15,
        height: 1.2,
      ),
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surfaceField,
        hintText: 'Search assets',
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.textTertiary,
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: AppColors.textTertiary,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.sm,
          borderSide: BorderSide(color: AppColors.borderStrong),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.sm,
          borderSide: BorderSide(color: AppColors.borderStrong),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.sm,
          borderSide: BorderSide(color: AppColors.accentLight, width: 2),
        ),
      ),
    );
  }
}
