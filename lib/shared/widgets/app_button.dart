import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// The three button treatments in the reference: the amber `.btn--primary`,
/// the bordered `.btn--outline`, and the shorter `.btn--sm` used for the
/// Google / Apple pair.
enum AppButtonVariant { primary, outline, subtle }

/// One button for the whole app.
///
/// A new treatment belongs on [AppButtonVariant], not in a second widget - the
/// height, radius, colours and text style all key off the variant.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;

  /// Null disables the button; so does [isLoading].
  final VoidCallback? onPressed;

  final AppButtonVariant variant;

  /// Replaces the label with a spinner and blocks taps.
  final bool isLoading;

  /// Optional leading glyph.
  final IconData? icon;

  double get _height =>
      variant == AppButtonVariant.subtle ? 52 : AppSpacing.minTapTarget + 8;

  BorderRadius get _radius =>
      variant == AppButtonVariant.subtle ? AppRadii.sm : AppRadii.md;

  Color get _background => switch (variant) {
    AppButtonVariant.primary => AppColors.accent,
    AppButtonVariant.outline => AppColors.surfaceField,
    AppButtonVariant.subtle => AppColors.surface,
  };

  Color get _foreground => switch (variant) {
    AppButtonVariant.primary => AppColors.onAccent,
    AppButtonVariant.outline => AppColors.textPrimary,
    AppButtonVariant.subtle => AppColors.icon,
  };

  Color? get _borderColour => switch (variant) {
    AppButtonVariant.primary => null,
    AppButtonVariant.outline => AppColors.borderStrong,
    AppButtonVariant.subtle => AppColors.borderStrong,
  };

  TextStyle get _textStyle => variant == AppButtonVariant.subtle
      ? AppTextStyles.buttonSmall.copyWith(color: _foreground)
      : AppTextStyles.button.copyWith(color: _foreground);

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final border = _borderColour;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Material(
          color: _background,
          borderRadius: _radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: Container(
              height: _height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: _radius,
                border: border == null ? null : Border.all(color: border),
              ),
              child: isLoading
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: _foreground,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (icon != null) ...<Widget>[
                          Icon(icon, size: 18, color: _foreground),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Flexible(
                          child: Text(
                            label,
                            style: _textStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
