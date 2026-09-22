/// The six figures under an asset's chart.
final class MarketStats {
  const MarketStats({
    required this.high24h,
    required this.low24h,
    required this.marketCap,
    required this.volume24h,
    required this.change7dPercent,
    required this.circulatingSupply,
  });

  final double high24h;
  final double low24h;
  final double marketCap;
  final double volume24h;

  /// Signed percentage move over seven sessions.
  final double change7dPercent;

  final double circulatingSupply;
}
