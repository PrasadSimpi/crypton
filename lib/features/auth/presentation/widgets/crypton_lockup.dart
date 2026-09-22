import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/crypton_mark.dart';

/// The small mark-plus-wordmark used in the sign-in top bar.
class CryptonLockup extends StatelessWidget {
  const CryptonLockup({super.key, this.markSize = 26});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Crypton',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Heavier strokes and no dot: at 26px the reference weights hold up
          // better than the splash ones, which vanish at this scale.
          CryptonMark(
            size: markSize,
            hexStrokeWidth: 5,
            lineStrokeWidth: 7,
            showDot: false,
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Text(
            'CRYPTON',
            style: AppTextStyles.numeralLarge.copyWith(letterSpacing: 2.4),
          ),
        ],
      ),
    );
  }
}
