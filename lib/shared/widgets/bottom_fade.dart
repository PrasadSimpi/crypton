import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The gradient that dissolves scrolling content into the background behind the
/// floating nav pill (`.fade`).
///
/// Purely decorative, so it ignores pointers and is hidden from semantics.
class BottomFade extends StatelessWidget {
  const BottomFade({super.key, this.height = 132});

  final double height;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0x000A0B0D),
                Color(0xDB0A0B0D),
                AppColors.bg,
              ],
              stops: <double>[0, 0.46, 1],
            ),
          ),
        ),
      ),
    );
  }
}
