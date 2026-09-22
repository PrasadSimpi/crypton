import '../../../core/utils/result.dart';
import 'entities/candle.dart';
import 'entities/coin.dart';
import 'entities/market_stats.dart';

/// Read access to market data.
///
/// Implemented in `data/` and injected through a provider, so a screen can be
/// tested against a fake without touching the mock fixtures.
abstract interface class MarketRepository {
  /// The assets on the user's watchlist, in their chosen order.
  Future<Result<List<Coin>>> watchlist();

  /// Every asset the app lists.
  Future<Result<List<Coin>>> allCoins();

  /// A single asset by ticker.
  Future<Result<Coin>> coin(String symbol);

  /// Daily bars for [symbol], oldest first.
  Future<Result<List<Candle>>> candles(String symbol);

  /// The stat block under [symbol]'s chart.
  Future<Result<MarketStats>> stats(String symbol);
}
