/// Windows offered on the dashboard hero chart.
enum Timeframe {
  day('1D'),
  week('1W'),
  month('1M'),
  sixMonths('6M'),
  year('1Y'),
  all('ALL');

  const Timeframe(this.label);

  /// Chip text.
  final String label;
}

/// Windows offered on the asset-detail candlestick chart.
enum CandleTimeframe {
  hour('1H'),
  eightHours('8H'),
  day('1D'),
  week('1W'),
  month('1M'),
  sixMonths('6M'),
  year('1Y');

  const CandleTimeframe(this.label);

  /// Chip text.
  final String label;
}
