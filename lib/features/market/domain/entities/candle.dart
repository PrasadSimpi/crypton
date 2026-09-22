/// One OHLC bar.
///
/// The invariants the chart relies on - `high >= max(open, close)`,
/// `low <= min(open, close)`, and each bar opening at the previous close - are
/// guaranteed by the data source, and asserted here so a bad fixture fails
/// loudly in debug rather than drawing a nonsense candle.
final class Candle {
  const Candle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  }) : assert(high >= open && high >= close, 'high must top the body'),
       assert(low <= open && low <= close, 'low must sit under the body');

  final double open;
  final double high;
  final double low;
  final double close;

  /// True when the bar closed at or above its open - drawn in the gain colour.
  bool get isUp => close >= open;

  /// Vertical extent of the body, never negative.
  double get bodyHeight => (close - open).abs();
}
