import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The bordered dark panel every grouped block sits in (`.card` in the
/// reference).
///
/// Reusable: [padding], [borderRadius], [color] and [border] are all overridable,
/// so the mini stat tiles and the settings group use this same widget rather
/// than rebuilding a `BoxDecoration`.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.borderRadius = AppRadii.xl,
    this.color = AppColors.surface,
    this.borderColor = AppColors.border,
    this.margin,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color color;
  final Color borderColor;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
