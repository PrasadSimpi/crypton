import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The soft amber glow behind the splash mark and in the sign-in corner.
///
/// Decorative: no semantics, no pointer interaction.
class AccentBloom extends StatelessWidget {
  const AccentBloom({
    required this.diameter,
    super.key,
    this.opacity = 0.10,
    this.edge = 0.68,
  });

  final double diameter;

  /// Alpha at the centre of the glow.
  final double opacity;

  /// Where the gradient reaches fully transparent, 0..1 of the radius.
  final double edge;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.square(
        dimension: diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                AppColors.accent.withValues(alpha: opacity),
                AppColors.accent.withValues(alpha: 0),
              ],
              stops: <double>[0, edge],
            ),
          ),
        ),
      ),
    );
  }
}
