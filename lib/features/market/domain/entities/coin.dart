/// A tradable asset as the market sees it.
///
/// Pure Dart on purpose: no Flutter import, no colour, no formatting. The
/// presentation layer decides how a price looks; this only knows what it is.
final class Coin {
  const Coin({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent24h,
    required this.circulatingSupply,
    required this.volume24h,
    required this.sparkline,
    this.priceDecimals = 2,
    this.quantityDecimals = 4,
  });

  /// Ticker, upper case: `BTC`.
  final String symbol;

  /// Display name: `Bitcoin`.
  final String name;

  /// Last traded price in the display currency.
  final double price;

  /// Signed percentage move over the last 24 hours.
  final double changePercent24h;

  /// Units in circulation - drives market cap.
  final double circulatingSupply;

  /// Traded value over the last 24 hours.
  final double volume24h;

  /// 18 points normalised to 0..1, low to high, for the row sparkline.
  final List<double> sparkline;

  /// Decimals this asset's price is normally quoted to.
  final int priceDecimals;

  /// Decimals a holding of this asset is normally quoted to.
  final int quantityDecimals;

  /// Price 24 hours ago, implied by [changePercent24h].
  double get previousClose => price / (1 + changePercent24h / 100);

  /// Signed absolute move over the last 24 hours.
  double get changeAbsolute24h => price - previousClose;

  /// Price times supply.
  double get marketCap => price * circulatingSupply;

  bool get isUp => changePercent24h >= 0;
}
