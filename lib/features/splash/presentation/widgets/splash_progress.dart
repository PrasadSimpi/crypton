import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The 132x3 amber progress bar and its caption at the foot of the splash.
class SplashProgress extends StatelessWidget {
  const SplashProgress({
    required this.progress,
    required this.caption,
    super.key,
  });

  /// 0..1 fill.
  final double progress;

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(
          label: 'Loading',
          value: '${(progress.clamp(0.0, 1.0) * 100).round()}%',
          child: ClipRRect(
            borderRadius: AppRadii.pill,
            child: SizedBox(
              width: 132,
              height: 3,
              child: ColoredBox(
                color: Colors.white.withValues(alpha: 0.10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.accentDeep,
                            AppColors.accent,
                            AppColors.accentLight,
                          ],
                          stops: <double>[0, 0.6, 1],
                        ),
                      ),
                      child: SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.card),
        Text(caption, style: AppTextStyles.splashCaption),
      ],
    );
  }
}
