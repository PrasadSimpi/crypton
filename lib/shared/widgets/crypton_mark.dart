import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The Crypton logo: a pointy-top hexagon with an ascending line and an end
/// dot, drawn in a 120x120 box and scaled to [size].
///
/// The three progress values drive the splash's stroke-on animation and default
/// to 1, so the same widget renders the finished mark in the sign-in header.
class CryptonMark extends StatelessWidget {
  const CryptonMark({
    required this.size,
    super.key,
    this.hexProgress = 1,
    this.lineProgress = 1,
    this.dotProgress = 1,
    this.hexStrokeWidth = 2.6,
    this.lineStrokeWidth = 3.4,
    this.showDot = true,
  });

  final double size;

  /// 0..1 along the hexagon outline.
  final double hexProgress;

  /// 0..1 along the ascending line.
  final double lineProgress;

  /// 0..1 scale of the end dot.
  final double dotProgress;

  /// Stroke widths in 120-unit design space, so they scale with [size]. The
  /// small header lockup uses heavier values to stay visible.
  final double hexStrokeWidth;
  final double lineStrokeWidth;

  /// The dot is dropped in the small lockup, where it would read as noise.
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _CryptonMarkPainter(
          hexProgress: hexProgress,
          lineProgress: lineProgress,
          dotProgress: showDot ? dotProgress : 0,
          hexStrokeWidth: hexStrokeWidth,
          lineStrokeWidth: lineStrokeWidth,
        ),
      ),
    );
  }
}

class _CryptonMarkPainter extends CustomPainter {
  const _CryptonMarkPainter({
    required this.hexProgress,
    required this.lineProgress,
    required this.dotProgress,
    required this.hexStrokeWidth,
    required this.lineStrokeWidth,
  });

  final double hexProgress;
  final double lineProgress;
  final double dotProgress;
  final double hexStrokeWidth;
  final double lineStrokeWidth;

  /// The mark is authored in a 120x120 box; everything below is in those units.
  static const double _designSize = 120;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _designSize;

    final hexagon = Path()
      ..moveTo(60 * s, 12 * s)
      ..lineTo(101.57 * s, 36 * s)
      ..lineTo(101.57 * s, 84 * s)
      ..lineTo(60 * s, 108 * s)
      ..lineTo(18.43 * s, 84 * s)
      ..lineTo(18.43 * s, 36 * s)
      ..close();

    _strokeFraction(
      canvas,
      hexagon,
      hexProgress,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = hexStrokeWidth * s
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = AppColors.accent,
    );

    final line = Path()
      ..moveTo(36 * s, 76 * s)
      ..lineTo(54 * s, 58 * s)
      ..lineTo(68 * s, 68 * s)
      ..lineTo(86 * s, 42 * s);

    _strokeFraction(
      canvas,
      line,
      lineProgress,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineStrokeWidth * s
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = AppColors.accentLight,
    );

    final dot = dotProgress.clamp(0.0, 1.0);
    if (dot > 0) {
      canvas.drawCircle(
        Offset(86 * s, 42 * s),
        5 * s * dot,
        Paint()..color = AppColors.accentLight.withValues(alpha: dot),
      );
    }
  }

  /// Draws the first [t] of [path]. The direct equivalent of animating CSS
  /// `stroke-dashoffset`.
  void _strokeFraction(Canvas canvas, Path path, double t, Paint paint) {
    final progress = t.clamp(0.0, 1.0);
    if (progress <= 0) return;
    if (progress >= 1) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(
        metric.extractPath(0, metric.length * progress),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CryptonMarkPainter old) =>
      old.hexProgress != hexProgress ||
      old.lineProgress != lineProgress ||
      old.dotProgress != dotProgress ||
      old.hexStrokeWidth != hexStrokeWidth ||
      old.lineStrokeWidth != lineStrokeWidth;
}
