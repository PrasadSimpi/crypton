import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// The round monogram chip that stands in for a coin logo (`.coin-chip`).
///
/// Deliberately a monogram on an invented tint rather than a brand mark. Below
/// 32 logical pixels it drops to a single letter, which is all that stays
/// legible.
class CoinAvatar extends StatelessWidget {
  const CoinAvatar({required this.symbol, super.key, this.size = 40});

  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ticker = symbol.toUpperCase();
    final compact = size < 32;
    final label = compact ? ticker.substring(0, 1) : ticker;

    return Semantics(
      label: ticker,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.coinSurface(ticker),
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: AppTextStyles.numeralTiny.copyWith(
            fontSize: compact ? size * 0.38 : 12,
            fontWeight: FontWeight.w700,
            color: AppColors.coinAccent(ticker),
          ),
          // The chip is a fixed circle, so this one label opts out of text
          // scaling rather than overflowing it.
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}
