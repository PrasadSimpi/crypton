import 'holding.dart';

/// The whole book: every [Holding] plus the figures that only make sense across
/// all of them.
///
/// Totals are computed, never stored. The only inputs are the positions
/// themselves and the two facts that cannot be derived from a snapshot - the
/// 24h move and the profit already booked.
final class PortfolioSummary {
  const PortfolioSummary({
    required this.holdings,
    required this.change24hAbsolute,
    required this.change24hPercent,
    required this.realisedPnl,
    required this.realisedExits,
    required this.valueSeries,
  });

  final List<Holding> holdings;

  /// Signed 24h move across the book, in the display currency.
  final double change24hAbsolute;

  /// Signed 24h move across the book, as a percentage.
  final double change24hPercent;

  /// Profit already taken.
  final double realisedPnl;

  /// How many closed positions produced [realisedPnl].
  final int realisedExits;

  /// Portfolio value over the charted window, normalised 0..1.
  final List<double> valueSeries;

  /// Sum of every position's market value.
  double get totalValue =>
      holdings.fold(0, (sum, holding) => sum + holding.marketValue);

  /// Sum of every position's cost basis.
  double get totalInvested =>
      holdings.fold(0, (sum, holding) => sum + holding.costBasis);

  /// Profit still open across the book.
  double get unrealisedPnl => totalValue - totalInvested;

  /// [unrealisedPnl] against [totalInvested].
  double get unrealisedPnlPercent =>
      totalInvested == 0 ? 0 : unrealisedPnl / totalInvested * 100;

  /// How many assets are held.
  int get assetCount => holdings.length;

  bool get isUp => change24hAbsolute >= 0;

  /// [holding]'s share of [totalValue], as a percentage.
  double allocationOf(Holding holding) =>
      totalValue == 0 ? 0 : holding.marketValue / totalValue * 100;

  /// Positions largest first - the order the Holdings list shows.
  List<Holding> get byValue => List<Holding>.of(holdings)
    ..sort((a, b) => b.marketValue.compareTo(a.marketValue));

  /// The position in [symbol], or null when the user holds none.
  Holding? holdingOf(String symbol) {
    final wanted = symbol.toUpperCase();
    for (final holding in holdings) {
      if (holding.symbol == wanted) return holding;
    }
    return null;
  }
}
