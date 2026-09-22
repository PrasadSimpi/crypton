import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../market/domain/entities/candle.dart';

/// Maps a price onto a vertical fraction of the chart box.
///
/// Shared by the painter and by the widgets that overlay it - the axis labels
/// and the live-price tag - so a label can never drift off its gridline.
final class CandleScale {
  const CandleScale({required this.high, required this.low});

  factory CandleScale.of(List<Candle> candles) {
    if (candles.isEmpty) return const CandleScale(high: 1, low: 0);
    var high = candles.first.high;
    var low = candles.first.low;
    for (final candle in candles) {
      high = math.max(high, candle.high);
      low = math.min(low, candle.low);
    }
    return CandleScale(high: high, low: low == high ? high - 1 : low);
  }

  final double high;
  final double low;

  /// Breathing room above and below the extremes, as a fraction of the box.
  /// 10 of the reference's 196 design units.
  static const double verticalInset = 10 / 196;

  /// Midpoint price - the centre gridline.
  double get mid => (high + low) / 2;

  /// Where [price] sits, 0 at the top of the box and 1 at the bottom.
  double fractionFor(double price) {
    final span = high - low;
    if (span <= 0) return 0.5;
    final t = (price - low) / span;
    return verticalInset + (1 - t) * (1 - verticalInset * 2);
  }

  /// The three gridline fractions, top to bottom.
  static const List<double> gridFractions = <double>[
    verticalInset,
    0.5,
    1 - verticalInset,
  ];
}

/// The candlestick chart.
///
/// [progress] reveals bars left to right, so the chart can draw itself on when
/// the screen opens rather than appearing fully formed.
class CandleChart extends StatelessWidget {
  const CandleChart({
    required this.candles,
    super.key,
    this.height = 168,
    this.progress = 1,
  });

  final List<Candle> candles;
  final double height;

  /// 0..1 of the series revealed.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${candles.length} price bars',
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _CandlePainter(
            candles: candles,
            scale: CandleScale.of(candles),
            progress: progress,
          ),
        ),
      ),
    );
  }
}

class _CandlePainter extends CustomPainter {
  const _CandlePainter({
    required this.candles,
    required this.scale,
    required this.progress,
  });

  final List<Candle> candles;
  final CandleScale scale;
  final double progress;

  /// The reference draws in a 350-unit-wide box; stroke widths are scaled from
  /// that so they keep their weight at any real width.
  static const double _designWidth = 350;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty || size.width <= 0) return;

    final sx = size.width / _designWidth;

    final grid = Paint()
      ..color = const Color(0xFF22262C)
      ..strokeWidth = 1;
    for (final fraction in CandleScale.gridFractions) {
      final y = fraction * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final pitch = size.width / candles.length;
    final bodyWidth = pitch * 0.56;
    final visible = (candles.length * progress.clamp(0.0, 1.0)).ceil();

    for (var i = 0; i < visible && i < candles.length; i++) {
      final candle = candles[i];
      final centreX = i * pitch + pitch / 2;
      final colour = candle.isUp ? AppColors.up : AppColors.down;

      final highY = scale.fractionFor(candle.high) * size.height;
      final lowY = scale.fractionFor(candle.low) * size.height;
      final openY = scale.fractionFor(candle.open) * size.height;
      final closeY = scale.fractionFor(candle.close) * size.height;

      // Wick.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            centreX - 0.7 * sx,
            highY,
            1.4 * sx,
            math.max(lowY - highY, 1),
          ),
          Radius.circular(0.7 * sx),
        ),
        Paint()..color = colour.withValues(alpha: 0.72),
      );

      // Body, never thinner than 2 logical pixels so a doji stays visible.
      final bodyTop = math.min(openY, closeY);
      final bodyHeight = math.max((closeY - openY).abs(), 2.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            centreX - bodyWidth / 2,
            bodyTop,
            bodyWidth,
            bodyHeight,
          ),
          Radius.circular(1.6 * sx),
        ),
        Paint()..color = colour,
      );
    }

    _drawLivePriceLine(canvas, size, sx);
  }

  /// The dashed amber rule at the last close.
  void _drawLivePriceLine(Canvas canvas, Size size, double sx) {
    final y = scale.fractionFor(candles.last.close) * size.height;
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.70)
      ..strokeWidth = 1;

    final dash = 3 * sx;
    final gap = 5 * sx;
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + dash, size.width), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CandlePainter old) =>
      old.progress != progress ||
      old.scale.high != scale.high ||
      old.scale.low != scale.low ||
      !identical(old.candles, candles);
}
