import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';

/// Money rendered the way the design does it: the whole part large, the cents
/// a step smaller on the same baseline.
///
/// Used by the hero balance, the portfolio metrics and the asset price, which
/// differ only in the two styles handed in.
class MoneyText extends StatelessWidget {
  const MoneyText({
    required this.value,
    required this.style,
    required this.fractionStyle,
    super.key,
    this.decimals = 2,
    this.withSymbol = true,
    this.signed = false,
    this.textAlign,
  });

  final double value;

  /// Style for the whole part.
  final TextStyle style;

  /// Style for the `.dd` tail.
  final TextStyle fractionStyle;

  final int decimals;
  final bool withSymbol;

  /// Forces a leading `+` on non-negative values.
  final bool signed;

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final parts = Formatters.moneyParts(
      value.abs(),
      decimals: decimals,
      withSymbol: withSymbol,
    );
    final prefix = value < 0
        ? Formatters.minus
        : (signed ? '+' : '');

    return Text.rich(
      TextSpan(
        text: '$prefix${parts.whole}',
        children: <InlineSpan>[
          TextSpan(text: parts.fraction, style: fractionStyle),
        ],
      ),
      style: style,
      textAlign: textAlign,
    );
  }
}
