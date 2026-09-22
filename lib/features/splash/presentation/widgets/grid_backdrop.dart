import 'package:flutter/material.dart';

/// The faint 39px graph-paper grid behind the splash mark, masked to a soft
/// oval so it fades out toward the edges.
///
/// Decorative only - excluded from semantics and non-interactive.
class GridBackdrop extends StatelessWidget {
  const GridBackdrop({super.key, this.cell = 39, this.opacity = 0.028});

  /// Grid pitch in logical pixels.
  final double cell;

  /// Line alpha.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect rect) => const RadialGradient(
            center: Alignment(0, -0.16),
            radius: 0.95,
            colors: <Color>[Colors.white, Colors.transparent],
            stops: <double>[0.35, 1],
          ).createShader(rect),
          child: CustomPaint(
            painter: _GridPainter(cell: cell, opacity: opacity),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.cell, required this.opacity});

  final double cell;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 1;

    for (var x = 0.0; x <= size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.cell != cell || old.opacity != opacity;
}
