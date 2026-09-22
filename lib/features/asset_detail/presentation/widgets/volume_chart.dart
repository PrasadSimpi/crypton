import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../market/domain/entities/candle.dart';

/// The volume strip under the candles.
///
/// The fixtures carry no traded volume, so bar height is derived from each
/// bar's body size relative to the chart's range - scale-free, so it reads the
/// same for a $66,000 asset and a $0.62 one - plus a deterministic wobble so
/// the strip does not look mechanical.
class VolumeChart extends StatelessWidget {
  const VolumeChart({
    required this.candles,
    super.key,
    this.height = 34,
    this.progress = 1,
  });

  final List<Candle> candles;
  final double height;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _VolumePainter(candles: candles, progress: progress),
        ),
      ),
    );
  }
}

class _VolumePainter extends CustomPainter {
  const _VolumePainter({required this.candles, required this.progress});

  final List<Candle> candles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty || size.width <= 0) return;

    var high = candles.first.high;
    var low = candles.first.low;
    for (final candle in candles) {
      high = math.max(high, candle.high);
      low = math.min(low, candle.low);
    }
    final range = high - low <= 0 ? 1.0 : high - low;

    final pitch = size.width / candles.length;
    final barWidth = pitch * 0.56;
    final visible = (candles.length * progress.clamp(0.0, 1.0)).ceil();

    for (var i = 0; i < visible && i < candles.length; i++) {
      final candle = candles[i];
      final activity = candle.bodyHeight / range;
      // 8 units of base, up to 90 units of body-driven height, plus a stable
      // 0-12 wobble, capped at the strip height.
      final units = math.min(8 + activity * 90 + ((i * 37) % 13) + 2, 40);
      final barHeight = units / 44 * size.height;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * pitch + pitch / 2 - barWidth / 2,
            size.height - barHeight,
            barWidth,
            barHeight,
          ),
          const Radius.circular(1.4),
        ),
        Paint()
          ..color = (candle.isUp ? AppColors.up : AppColors.down).withValues(
            alpha: 0.38,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumePainter old) =>
      old.progress != progress || !identical(old.candles, candles);
}
