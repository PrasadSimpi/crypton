/// Money split into the two parts the design renders at different sizes:
/// `$41,812` in 42pt and `.14` in 26pt.
typedef MoneyParts = ({String whole, String fraction});

/// Number, currency and date formatting for the whole app.
///
/// Hand-rolled rather than pulled from `intl`: the app ships one locale and one
/// currency, and this keeps the dependency list at two packages. Swapping
/// [currencySymbol] is the only change needed to re-denominate the UI; the day
/// a second locale lands, this class is what gets replaced by `intl`.
abstract final class Formatters {
  /// Crypto is quoted in USD throughout the reference design, so the app is
  /// too. Change this one constant to switch the display currency.
  static const String currencySymbol = r'$';

  /// U+2212 MINUS SIGN - optically balanced against `+`, unlike a hyphen.
  static const String minus = '−';

  static const List<String> _months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Groups an integer string in threes: `41812` becomes `41,812`.
  static String group(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Splits [value] into a grouped whole part and a `.dd` fraction.
  static MoneyParts moneyParts(
    double value, {
    int decimals = 2,
    bool withSymbol = true,
  }) {
    final text = value.abs().toStringAsFixed(decimals);
    final dot = text.indexOf('.');
    final wholeDigits = dot == -1 ? text : text.substring(0, dot);
    final fraction = dot == -1 ? '' : text.substring(dot);
    final sign = value < 0 ? minus : '';
    final symbol = withSymbol ? currencySymbol : '';
    return (whole: '$sign$symbol${group(wholeDigits)}', fraction: fraction);
  }

  /// `$66,858.75`
  static String money(
    double value, {
    int decimals = 2,
    bool withSymbol = true,
  }) {
    final parts = moneyParts(value, decimals: decimals, withSymbol: withSymbol);
    return '${parts.whole}${parts.fraction}';
  }

  /// `+$1,284.60` or the minus-sign equivalent. Always signed.
  static String signedMoney(double value, {int decimals = 2}) {
    final sign = value < 0 ? minus : '+';
    final parts = moneyParts(value.abs(), decimals: decimals);
    return '$sign${parts.whole}${parts.fraction}';
  }

  /// `+3.17%` or `-3.42%`. Always signed.
  static String signedPercent(double value, {int decimals = 2}) {
    final sign = value < 0 ? minus : '+';
    return '$sign${value.abs().toStringAsFixed(decimals)}%';
  }

  /// `47.23%`, unsigned.
  static String percent(double value, {int decimals = 2}) =>
      '${value.toStringAsFixed(decimals)}%';

  /// A coin quantity at the precision that asset is normally quoted in:
  /// `0.4215`, `2,521.9`.
  static String quantity(double value, {int decimals = 4}) {
    final text = value.toStringAsFixed(decimals);
    final dot = text.indexOf('.');
    if (dot == -1) return group(text);
    return '${group(text.substring(0, dot))}${text.substring(dot)}';
  }

  /// `1.32T`, `28.4B`, `19.74M`.
  ///
  /// With [decimals] left null the precision adapts to magnitude, which reads
  /// best in a stat tile; pass a value to pin it.
  static String compact(double value, {int? decimals}) {
    const steps = <(double, String)>[
      (1e12, 'T'),
      (1e9, 'B'),
      (1e6, 'M'),
      (1e3, 'K'),
    ];
    for (final (threshold, suffix) in steps) {
      if (value.abs() >= threshold) {
        final scaled = value / threshold;
        final places =
            decimals ?? (scaled.abs() >= 100 ? 0 : (scaled.abs() >= 10 ? 1 : 2));
        return '${scaled.toStringAsFixed(places)}$suffix';
      }
    }
    return value.toStringAsFixed(decimals ?? 0);
  }

  /// `02 Sep` - chart axis ticks.
  static String dayMonth(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]}';

  /// `Jan 2024` - the profile "member since" tile.
  static String monthYear(DateTime date) =>
      '${_months[date.month - 1]} ${date.year}';
}
