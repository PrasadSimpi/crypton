import 'package:flutter/material.dart';

/// Fades [child] in while it rises [offsetY] logical pixels.
///
/// [t] is driven by an animation elsewhere, so this stays a cheap stateless
/// transform that can be rebuilt inside an `AnimatedBuilder` without owning a
/// controller of its own.
class FadeUp extends StatelessWidget {
  const FadeUp({
    required this.t,
    required this.child,
    super.key,
    this.offsetY = 10,
  });

  /// Progress, 0..1. Values outside the range are clamped.
  final double t;

  final double offsetY;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final progress = t.clamp(0.0, 1.0);
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, offsetY * (1 - progress)),
        child: child,
      ),
    );
  }
}
