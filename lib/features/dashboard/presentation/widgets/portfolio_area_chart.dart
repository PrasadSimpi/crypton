import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The smoothed area chart inside the amber hero card.
///
/// Takes points already normalised to 0..1 and draws them as a Catmull-Rom
/// spline - the direct equivalent of the cubic path in the reference SVG.
/// [progress] reveals the line from the left, so the dashboard can draw it on
/// once when the data lands.
class PortfolioAreaChart extends StatelessWidget {
  const PortfolioAreaChart({
    required this.points,
    super.key,
    this.height = 86,
    this.lineColor = AppColors.onAccent,
    this.strokeWidth = 2.4,
    this.progress = 1,
  });

  final List<double> points;
  final double height;
  final Color lineColor;
  final double strokeWidth;

  /// 0..1 of the line drawn so far.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _AreaPainter(
            points: points,
            lineColor: lineColor,
            strokeWidth: strokeWidth,
            progress: progress,
          ),
        ),
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  const _AreaPainter({
    required this.points,
    required this.lineColor,
    required this.strokeWidth,
    required this.progress,
  });

  final List<double> points;
  final Color lineColor;
  final double strokeWidth;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2 || size.width <= 0) return;

    final t = progress.clamp(0.0, 1.0);
    if (t <= 0) return;

    // Keep the stroke and the end dot inside the box at both extremes.
    final inset = strokeWidth * 2;
    final usableHeight = size.height - inset * 2;
    final step = size.width / (points.length - 1);

    final vertices = <Offset>[
      for (var i = 0; i < points.length; i++)
        Offset(
          i * step,
          inset + (1 - points[i].clamp(0.0, 1.0)) * usableHeight,
        ),
    ];

    final line = _spline(vertices);
    final visible = _fraction(line, t);

    // Fill first, so the stroke sits on top of its own gradient.
    final metrics = visible.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final end = metrics.last.getTangentForOffset(metrics.last.length);
      final endPoint = end?.position ?? vertices.last;

      final fill = Path.from(visible)
        ..lineTo(endPoint.dx, size.height)
        ..lineTo(0, size.height)
        ..close();

      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              lineColor.withValues(alpha: 0.26),
              lineColor.withValues(alpha: 0),
            ],
          ).createShader(Offset.zero & size),
      );

      canvas.drawPath(
        visible,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = lineColor,
      );

      canvas.drawCircle(endPoint, 4, Paint()..color = lineColor);
    }
  }

  /// A Catmull-Rom spline through [vertices], converted to cubic segments.
  static Path _spline(List<Offset> vertices) {
    final path = Path()..moveTo(vertices.first.dx, vertices.first.dy);
    for (var i = 0; i < vertices.length - 1; i++) {
      final previous = i == 0 ? vertices[0] : vertices[i - 1];
      final current = vertices[i];
      final next = vertices[i + 1];
      final after = i + 2 < vertices.length ? vertices[i + 2] : next;

      final c1 = Offset(
        current.dx + (next.dx - previous.dx) / 6,
        current.dy + (next.dy - previous.dy) / 6,
      );
      final c2 = Offset(
        next.dx - (after.dx - current.dx) / 6,
        next.dy - (after.dy - current.dy) / 6,
      );
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, next.dx, next.dy);
    }
    return path;
  }

  /// The first [t] of [source].
  static Path _fraction(Path source, double t) {
    if (t >= 1) return source;
    final result = Path();
    for (final metric in source.computeMetrics()) {
      result.addPath(metric.extractPath(0, metric.length * t), Offset.zero);
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _AreaPainter old) =>
      old.progress != progress ||
      old.lineColor != lineColor ||
      old.strokeWidth != strokeWidth ||
      !identical(old.points, points);
}
