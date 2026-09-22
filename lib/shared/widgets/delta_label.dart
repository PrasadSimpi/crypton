import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';

/// A signed change, coloured green or red.
///
/// The arrow is not decoration: colour alone must never carry the direction, so
/// every delta that matters ships [showArrow] on, and the sign character is
/// present either way for anyone reading it aloud.
class DeltaLabel extends StatelessWidget {
  const DeltaLabel({
    required this.value,
    super.key,
    this.style,
    this.isPercent = true,
    this.decimals = 2,
    this.showArrow = false,
    this.upColor = AppColors.up,
    this.downColor = AppColors.downText,
    this.arrowSize = 12,
  });

  /// Signed magnitude: a percentage when [isPercent], otherwise money.
  final double value;

  final TextStyle? style;
  final bool isPercent;
  final int decimals;
  final bool showArrow;
  final Color upColor;
  final Color downColor;
  final double arrowSize;

  bool get _isUp => value >= 0;

  @override
  Widget build(BuildContext context) {
    final colour = _isUp ? upColor : downColor;
    final text = isPercent
        ? Formatters.signedPercent(value, decimals: decimals)
        : Formatters.signedMoney(value, decimals: decimals);
    final resolved = (style ?? AppTextStyles.numeralTiny).copyWith(
      color: colour,
    );

    if (!showArrow) return Text(text, style: resolved);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          _isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: arrowSize,
          color: colour,
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(text, style: resolved),
      ],
    );
  }
}
