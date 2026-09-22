import 'package:crypton/features/portfolio/domain/entities/holding.dart';
import 'package:crypton/features/portfolio/domain/entities/portfolio_summary.dart';
import 'package:flutter_test/flutter_test.dart';

/// The book from the design reference. Every total below is derived, so these
/// tests are what stop a figure on screen drifting away from the others.
PortfolioSummary _summary() => const PortfolioSummary(
  holdings: <Holding>[
    Holding(
      symbol: 'BTC',
      name: 'Bitcoin',
      quantity: 0.4215,
      averageCost: 44839.86,
      price: 66858.75,
    ),
    Holding(
      symbol: 'ETH',
      name: 'Ethereum',
      quantity: 2.48,
      averageCost: 2500,
      price: 3512.40,
    ),
    Holding(
      symbol: 'SOL',
      name: 'Solana',
      quantity: 18.24,
      averageCost: 117.87,
      price: 184.26,
    ),
    Holding(
      symbol: 'XRP',
      name: 'XRP',
      quantity: 2521.9,
      averageCost: 0.456,
      price: 0.6184,
    ),
  ],
  change24hAbsolute: 1284.60,
  change24hPercent: 3.17,
  realisedPnl: 3845.20,
  realisedExits: 12,
  valueSeries: <double>[0, 1],
);

void main() {
  group('Holding', () {
    test('derives value, cost and profit from quantity and price', () {
      const holding = Holding(
        symbol: 'BTC',
        name: 'Bitcoin',
        quantity: 0.4215,
        averageCost: 44839.86,
        price: 66858.75,
      );

      expect(holding.marketValue, closeTo(28180.96, 0.01));
      expect(holding.costBasis, closeTo(18900.00, 0.01));
      expect(holding.unrealisedPnl, closeTo(9280.96, 0.01));
      expect(holding.unrealisedPnlPercent, closeTo(49.1, 0.05));
    });

    test('reports a loss when the price is below the average cost', () {
      const holding = Holding(
        symbol: 'SOL',
        name: 'Solana',
        quantity: 10,
        averageCost: 200,
        price: 180,
      );

      expect(holding.isUp, isFalse);
      expect(holding.unrealisedPnl, closeTo(-200, 0.01));
    });
  });

  group('PortfolioSummary', () {
    test('totals match the reference figures', () {
      final portfolio = _summary();

      expect(portfolio.totalInvested, closeTo(28400.00, 0.1));
      expect(portfolio.totalValue, closeTo(41812.15, 0.05));
      expect(portfolio.unrealisedPnl, closeTo(13412.15, 0.1));
      expect(portfolio.unrealisedPnlPercent, closeTo(47.23, 0.01));
    });

    test('allocations are shares of the total and sum to 100', () {
      final portfolio = _summary();
      final total = portfolio.holdings
          .map(portfolio.allocationOf)
          .reduce((double a, double b) => a + b);

      expect(total, closeTo(100, 0.001));
      expect(
        portfolio.allocationOf(portfolio.holdings.first),
        closeTo(67.4, 0.05),
      );
    });

    test('byValue orders positions largest first', () {
      final ordered = _summary().byValue.map((Holding h) => h.symbol).toList();
      expect(ordered, <String>['BTC', 'ETH', 'SOL', 'XRP']);
    });

    test('holdingOf finds a position regardless of case', () {
      expect(_summary().holdingOf('btc')?.symbol, 'BTC');
      expect(_summary().holdingOf('DOGE'), isNull);
    });
  });
}
