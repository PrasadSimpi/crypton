import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/mock_market_repository.dart';
import '../../domain/entities/candle.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/market_stats.dart';
import '../../domain/entities/timeframe.dart';
import '../../domain/market_repository.dart';

/// The one place the app names a concrete repository. Swapping in a live
/// implementation is a one-line change here; nothing above it moves.
final marketRepositoryProvider = Provider<MarketRepository>(
  (ref) => const MockMarketRepository(),
);

/// Assets shown on the dashboard watchlist and the Markets tab.
final watchlistProvider =
    AsyncNotifierProvider<WatchlistController, List<Coin>>(
      WatchlistController.new,
    );

final class WatchlistController extends AsyncNotifier<List<Coin>> {
  @override
  Future<List<Coin>> build() async =>
      (await ref.watch(marketRepositoryProvider).watchlist()).unwrap();

  /// Re-fetch. Used by pull-to-refresh and by the error state's Retry button.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async =>
          (await ref.read(marketRepositoryProvider).watchlist()).unwrap(),
    );
  }
}

/// Everything shown on one asset-detail screen, fetched concurrently so the
/// screen waits on the slowest call rather than the sum of all three.
typedef AssetDetailView = ({
  Coin coin,
  List<Candle> candles,
  MarketStats stats,
});

final assetDetailProvider =
    FutureProvider.family<AssetDetailView, String>((ref, symbol) async {
      final repository = ref.watch(marketRepositoryProvider);

      final coinRequest = repository.coin(symbol);
      final candlesRequest = repository.candles(symbol);
      final statsRequest = repository.stats(symbol);

      return (
        coin: (await coinRequest).unwrap(),
        candles: (await candlesRequest).unwrap(),
        stats: (await statsRequest).unwrap(),
      );
    });

/// Selected window on the dashboard hero chart.
final dashboardTimeframeProvider =
    NotifierProvider<DashboardTimeframeController, Timeframe>(
      DashboardTimeframeController.new,
    );

final class DashboardTimeframeController extends Notifier<Timeframe> {
  @override
  Timeframe build() => Timeframe.day;

  void select(Timeframe value) => state = value;
}

/// Selected window on the asset-detail candlestick chart.
final candleTimeframeProvider =
    NotifierProvider<CandleTimeframeController, CandleTimeframe>(
      CandleTimeframeController.new,
    );

final class CandleTimeframeController extends Notifier<CandleTimeframe> {
  @override
  CandleTimeframe build() => CandleTimeframe.day;

  void select(CandleTimeframe value) => state = value;
}

/// Tickers the user has starred. Mock-only: starring is local and resets with
/// the process.
final watchedSymbolsProvider =
    NotifierProvider<WatchedSymbolsController, Set<String>>(
      WatchedSymbolsController.new,
    );

final class WatchedSymbolsController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const <String>{'BTC', 'ETH', 'SOL', 'XRP'};

  bool isWatched(String symbol) => state.contains(symbol.toUpperCase());

  void toggle(String symbol) {
    final wanted = symbol.toUpperCase();
    state = state.contains(wanted)
        ? (Set<String>.of(state)..remove(wanted))
        : (Set<String>.of(state)..add(wanted));
  }
}
