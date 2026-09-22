import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The bordered "Skip" pill that drops the user straight into the app as a
/// guest.
class SkipButton extends StatelessWidget {
  const SkipButton({required this.onPressed, super.key, this.isBusy = false});

  final VoidCallback? onPressed;

  /// Swaps the arrow for a spinner while the guest session is being created.
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Skip sign in and browse as a guest',
      child: Material(
        color: AppColors.surfaceField,
        borderRadius: AppRadii.pill,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isBusy ? null : onPressed,
          child: Container(
            height: AppSpacing.minTapTarget,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppRadii.pill,
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Skip',
                  style: AppTextStyles.captionBold.copyWith(
                    fontSize: 13,
                    color: AppColors.icon,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm - 2),
                if (isBusy)
                  const SizedBox.square(
                    dimension: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.icon,
                    ),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppColors.icon,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
