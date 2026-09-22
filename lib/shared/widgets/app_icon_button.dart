import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The circular bordered icon button in every top bar (`.icon-btn`).
///
/// The painted circle is 44 to match the reference; the tap target is padded
/// out to 48 so it clears the Material minimum. [showBadge] draws the amber
/// unread dot.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.semanticLabel,
    super.key,
    this.onPressed,
    this.showBadge = false,
    this.foregroundColor = AppColors.icon,
    this.diameter = 44,
  });

  final IconData icon;

  /// Read aloud in place of the glyph - required, because the glyph alone says
  /// nothing to a screen reader.
  final String semanticLabel;

  final VoidCallback? onPressed;

  /// Draws the unread dot at the top-right.
  final bool showBadge;

  final Color foregroundColor;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final target = diameter < AppSpacing.minTapTarget
        ? AppSpacing.minTapTarget
        : diameter;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      child: Tooltip(
        message: semanticLabel,
        child: SizedBox.square(
          dimension: target,
          child: Center(
            child: Material(
              color: AppColors.surfaceField,
              shape: const CircleBorder(
                side: BorderSide(color: AppColors.borderStrong),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                child: SizedBox.square(
                  dimension: diameter,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(icon, size: 19, color: foregroundColor),
                      if (showBadge)
                        Positioned(
                          top: 9,
                          right: 11,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surfaceField,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
