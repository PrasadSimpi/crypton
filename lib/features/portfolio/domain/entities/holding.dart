/// One position: how much of an asset the user owns and what they paid.
///
/// Everything a holding row shows - market value, profit, percentage return -
/// is derived here rather than stored, so a price change updates every figure
/// at once and none of them can disagree.
final class Holding {
  const Holding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averageCost,
    required this.price,
    this.priceDecimals = 2,
    this.quantityDecimals = 4,
  });

  final String symbol;
  final String name;

  /// Units held.
  final double quantity;

  /// Weighted average price paid per unit.
  final double averageCost;

  /// Current market price per unit.
  final double price;

  final int priceDecimals;
  final int quantityDecimals;

  /// What the position is worth now.
  double get marketValue => quantity * price;

  /// What the position cost to build.
  double get costBasis => quantity * averageCost;

  /// Profit still on the table.
  double get unrealisedPnl => marketValue - costBasis;

  /// [unrealisedPnl] as a percentage of [costBasis].
  double get unrealisedPnlPercent =>
      costBasis == 0 ? 0 : unrealisedPnl / costBasis * 100;

  bool get isUp => unrealisedPnl >= 0;

  /// A copy repriced to [newPrice], for when market data refreshes under a
  /// position that has not itself changed.
  Holding copyWithPrice(double newPrice) => Holding(
    symbol: symbol,
    name: name,
    quantity: quantity,
    averageCost: averageCost,
    price: newPrice,
    priceDecimals: priceDecimals,
    quantityDecimals: quantityDecimals,
  );
}
