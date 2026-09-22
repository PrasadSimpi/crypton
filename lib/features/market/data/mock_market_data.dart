import 'dart:math' as math;

import '../domain/entities/candle.dart';
import '../domain/entities/coin.dart';
import '../domain/entities/market_stats.dart';

/// The fixture set behind every screen.
///
/// Only primitive facts live here - price, supply, the 22 real BTC bars. Market
/// cap, 24h high/low, 7-day change and every P&L figure are derived, so the
/// numbers on screen can never drift out of agreement with each other.
abstract final class MockMarketData {
  /// 22 daily BTC bars, oldest first, exactly as in the design reference.
  ///
  /// Each bar opens at the previous close; the last closes at 66,858.75 against
  /// a prior close of 65,457.86, which is the +2.14% the header shows.
  static const List<Candle> bitcoinCandles = <Candle>[
    Candle(open: 61200.00, high: 61661.31, low: 60752.98, close: 60766.29),
    Candle(open: 60766.29, high: 61705.64, low: 60752.98, close: 61494.95),
    Candle(open: 61494.95, high: 62299.79, low: 61479.87, close: 61905.38),
    Candle(open: 61905.38, high: 62357.09, low: 61432.90, close: 61604.87),
    Candle(open: 61604.87, high: 62608.14, low: 61430.10, close: 62201.77),
    Candle(open: 62201.77, high: 62874.84, low: 62018.99, close: 62628.63),
    Candle(open: 62628.63, high: 63334.57, low: 62487.90, close: 62850.65),
    Candle(open: 62850.65, high: 63635.16, low: 62690.44, close: 63359.18),
    Candle(open: 63359.18, high: 64123.54, low: 63178.24, close: 63598.42),
    Candle(open: 63598.42, high: 64888.77, low: 63450.77, close: 64506.10),
    Candle(open: 64506.10, high: 64990.28, low: 64502.94, close: 64591.45),
    Candle(open: 64591.45, high: 65327.63, low: 64444.29, close: 64823.18),
    Candle(open: 64823.18, high: 65420.32, low: 64673.43, close: 65205.47),
    Candle(open: 65205.47, high: 65553.36, low: 64628.76, close: 64656.36),
    Candle(open: 64656.36, high: 65437.60, low: 64520.18, close: 65051.87),
    Candle(open: 65051.87, high: 65816.31, low: 64951.30, close: 65380.72),
    Candle(open: 65380.72, high: 66148.34, low: 65360.22, close: 65663.55),
    Candle(open: 65663.55, high: 66336.63, low: 65559.90, close: 65847.63),
    Candle(open: 65847.63, high: 66029.14, low: 65494.31, close: 65545.36),
    Candle(open: 65545.36, high: 65697.99, low: 65145.35, close: 65471.71),
    Candle(open: 65471.71, high: 65788.40, low: 65210.55, close: 65457.86),
    Candle(open: 65457.86, high: 67092.31, low: 65102.44, close: 66858.75),
  ];

  /// Portfolio value over the charted window, normalised 0..1. Sampled from the
  /// hero area path in the reference so the curve keeps its exact shape.
  static const List<double> portfolioSeries = <double>[
    0.382, 0.300, 0.228, 0.149, 0.224, 0.221, 0.174, 0.161, 0.087, 0.204,
    0.276, 0.279, 0.320, 0.429, 0.346, 0.450, 0.476, 0.533, 0.540, 0.516,
    0.650, 0.683, 0.726, 0.753, 0.692, 0.800, 0.847, 0.770, 0.724, 0.767,
    0.849, 0.889, 0.913, 0.865,
  ];

  /// Signed 24h move on the whole portfolio, in the display currency.
  static const double portfolioChange24hAbsolute = 1284.60;

  /// Signed 24h move on the whole portfolio, as a percentage.
  static const double portfolioChange24hPercent = 3.17;

  /// Profit already booked, and how many exits produced it.
  static const double realisedPnl = 3845.20;
  static const int realisedExits = 12;

  static const List<Coin> coins = <Coin>[
    Coin(
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 66858.75,
      changePercent24h: 2.14,
      circulatingSupply: 19.74e6,
      volume24h: 28.4e9,
      sparkline: <double>[
        0.88, 0.76, 0.90, 0.72, 0.80, 0.78, 0.58, 0.68, 0.44,
        0.50, 0.28, 0.14, 0.06, 0.16, 0.34, 0.24, 0.12, 0.42,
      ],
    ),
    Coin(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3512.40,
      changePercent24h: 1.08,
      circulatingSupply: 120.31e6,
      volume24h: 14.2e9,
      sparkline: <double>[
        0.42, 0.56, 0.62, 0.66, 0.62, 0.90, 0.82, 0.72, 0.66,
        0.58, 0.54, 0.50, 0.40, 0.32, 0.28, 0.24, 0.28, 0.14,
      ],
    ),
    Coin(
      symbol: 'SOL',
      name: 'Solana',
      price: 184.26,
      changePercent24h: -3.42,
      circulatingSupply: 468.2e6,
      volume24h: 3.8e9,
      quantityDecimals: 3,
      sparkline: <double>[
        0.18, 0.22, 0.70, 0.14, 0.24, 0.52, 0.94, 0.38, 0.52,
        0.56, 0.30, 0.82, 0.88, 0.62, 0.50, 0.88, 0.58, 0.14,
      ],
    ),
    Coin(
      symbol: 'XRP',
      name: 'XRP',
      price: 0.6184,
      changePercent24h: 0.86,
      circulatingSupply: 56.13e9,
      volume24h: 1.9e9,
      priceDecimals: 4,
      quantityDecimals: 1,
      sparkline: <double>[
        0.14, 0.10, 0.04, 0.24, 0.32, 0.40, 0.42, 0.50, 0.58,
        0.68, 0.76, 0.84, 0.92, 0.94, 0.86, 0.80, 0.88, 0.84,
      ],
    ),
  ];

  /// Bars for [coin]: the real series for BTC, a deterministic synthetic one
  /// for the rest.
  ///
  /// The synthetic series reuses the coin's own sparkline as its close-price
  /// shape, scales it so the penultimate bar lands on the price implied by the
  /// 24h move, and appends one bar closing at the live price. That keeps the
  /// chart's direction honest - SOL, which is down on the day, ends red.
  static List<Candle> candlesFor(Coin coin) {
    if (coin.symbol == 'BTC') return bitcoinCandles;

    final shape = coin.sparkline;
    final low = shape.reduce(math.min);
    final high = shape.reduce(math.max);
    final span = high - low;

    // Map the 0..1 shape onto a +/-6% band, then rescale so its last point is
    // exactly the price 24 hours ago.
    double band(double v) => 0.94 + 0.12 * (span == 0 ? 0.5 : (v - low) / span);
    final anchor = coin.previousClose / band(shape.last);
    final closes = <double>[for (final v in shape) band(v) * anchor];

    final candles = <Candle>[];
    var open = closes.first * 0.996;
    for (var i = 0; i < closes.length; i++) {
      final close = closes[i];
      // Deterministic wick jitter: stable across rebuilds, no Random seed to
      // thread through, and never large enough to break the OHLC invariants.
      final jitter = 0.002 + ((i * 37) % 11) * 0.0006;
      candles.add(
        Candle(
          open: open,
          high: math.max(open, close) * (1 + jitter),
          low: math.min(open, close) * (1 - jitter),
          close: close,
        ),
      );
      open = close;
    }

    candles.add(
      Candle(
        open: coin.previousClose,
        high: math.max(coin.previousClose, coin.price) * 1.006,
        low: math.min(coin.previousClose, coin.price) * 0.992,
        close: coin.price,
      ),
    );
    return candles;
  }

  /// Stats for [coin], derived from its bars so the tiles always agree with the
  /// chart above them.
  static MarketStats statsFor(Coin coin) {
    final candles = candlesFor(coin);
    final last = candles.last;
    // Seven sessions back from the latest bar.
    final weekAgo = candles[math.max(0, candles.length - 8)].close;

    return MarketStats(
      high24h: last.high,
      low24h: last.low,
      marketCap: coin.marketCap,
      volume24h: coin.volume24h,
      change7dPercent: (last.close - weekAgo) / weekAgo * 100,
      circulatingSupply: coin.circulatingSupply,
    );
  }
}
