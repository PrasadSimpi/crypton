import '../../../core/errors/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/entities/candle.dart';
import '../domain/entities/coin.dart';
import '../domain/entities/market_stats.dart';
import '../domain/market_repository.dart';
import 'mock_market_data.dart';

/// Serves [MockMarketData] behind a short delay, so every screen exercises its
/// real loading state instead of painting fully-formed on the first frame.
final class MockMarketRepository implements MarketRepository {
  const MockMarketRepository({
    this.latency = const Duration(milliseconds: 420),
  });

  final Duration latency;

  @override
  Future<Result<List<Coin>>> watchlist() async {
    await Future<void>.delayed(latency);
    return const Ok(MockMarketData.coins);
  }

  @override
  Future<Result<List<Coin>>> allCoins() async {
    await Future<void>.delayed(latency);
    return const Ok(MockMarketData.coins);
  }

  @override
  Future<Result<Coin>> coin(String symbol) async {
    await Future<void>.delayed(latency);
    final match = _find(symbol);
    return match == null ? const Err(NotFoundFailure()) : Ok(match);
  }

  @override
  Future<Result<List<Candle>>> candles(String symbol) async {
    await Future<void>.delayed(latency);
    final match = _find(symbol);
    if (match == null) return const Err(NotFoundFailure());
    return Ok(MockMarketData.candlesFor(match));
  }

  @override
  Future<Result<MarketStats>> stats(String symbol) async {
    await Future<void>.delayed(latency);
    final match = _find(symbol);
    if (match == null) return const Err(NotFoundFailure());
    return Ok(MockMarketData.statsFor(match));
  }

  Coin? _find(String symbol) {
    final wanted = symbol.toUpperCase();
    for (final coin in MockMarketData.coins) {
      if (coin.symbol == wanted) return coin;
    }
    return null;
  }
}
