import 'package:flutter/material.dart';

/// The 56x24 trend line on a watchlist row.
///
/// Takes points already normalised to 0..1 - the domain layer decides what
/// "high" and "low" mean, this only draws.
class Sparkline extends StatelessWidget {
  const Sparkline({
    required this.points,
    required this.color,
    super.key,
    this.width = 56,
    this.height = 24,
    this.strokeWidth = 1.6,
  });

  final List<double> points;
  final Color color;
  final double width;
  final double height;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _SparklinePainter(
            points: points,
            color: color,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final List<double> points;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    // 3px of breathing room top and bottom so the stroke is never clipped.
    const inset = 3.0;
    final step = size.width / (points.length - 1);
    final usable = size.height - inset * 2;

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = i * step;
      final y = inset + (1 - points[i].clamp(0.0, 1.0)) * usable;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      !identical(old.points, points);
}
