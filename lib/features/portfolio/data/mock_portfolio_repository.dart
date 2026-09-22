import '../../../core/utils/result.dart';
import '../../market/data/mock_market_data.dart';
import '../domain/entities/holding.dart';
import '../domain/entities/portfolio_summary.dart';
import '../domain/portfolio_repository.dart';

/// A fixed book of four positions, priced off [MockMarketData].
///
/// Quantities and average costs are the only stored numbers. Every total in the
/// UI falls out of them: cost basis sums to 28,400.00 and market value to
/// 41,812.15, which is the +47.23% all-time return the design shows.
final class MockPortfolioRepository implements PortfolioRepository {
  const MockPortfolioRepository({
    this.latency = const Duration(milliseconds: 460),
  });

  final Duration latency;

  static const Map<String, ({double quantity, double averageCost})> _positions =
      <String, ({double quantity, double averageCost})>{
        'BTC': (quantity: 0.4215, averageCost: 44839.86),
        'ETH': (quantity: 2.4800, averageCost: 2500.00),
        'SOL': (quantity: 18.240, averageCost: 117.87),
        'XRP': (quantity: 2521.9, averageCost: 0.4560),
      };

  @override
  Future<Result<PortfolioSummary>> loadPortfolio() async {
    await Future<void>.delayed(latency);

    final holdings = <Holding>[];
    for (final coin in MockMarketData.coins) {
      final position = _positions[coin.symbol];
      if (position == null) continue;
      holdings.add(
        Holding(
          symbol: coin.symbol,
          name: coin.name,
          quantity: position.quantity,
          averageCost: position.averageCost,
          price: coin.price,
          priceDecimals: coin.priceDecimals,
          quantityDecimals: coin.quantityDecimals,
        ),
      );
    }

    return Ok(
      PortfolioSummary(
        holdings: holdings,
        change24hAbsolute: MockMarketData.portfolioChange24hAbsolute,
        change24hPercent: MockMarketData.portfolioChange24hPercent,
        realisedPnl: MockMarketData.realisedPnl,
        realisedExits: MockMarketData.realisedExits,
        valueSeries: MockMarketData.portfolioSeries,
      ),
    );
  }
}
