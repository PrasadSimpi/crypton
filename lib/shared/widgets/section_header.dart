import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// A section title with an optional trailing action or eyebrow
/// (`.section-head`).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
    this.trailingLabel,
  });

  final String title;

  /// Renders an accent text button on the right.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// A non-interactive caption on the right, e.g. `BY VALUE`. Ignored when
  /// [actionLabel] is set.
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    final action = actionLabel;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            title,
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                AppSpacing.minTapTarget,
                AppSpacing.minTapTarget,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(action, style: AppTextStyles.link),
          )
        else if (trailingLabel != null)
          Text(trailingLabel!, style: AppTextStyles.eyebrow),
      ],
    );
  }
}
