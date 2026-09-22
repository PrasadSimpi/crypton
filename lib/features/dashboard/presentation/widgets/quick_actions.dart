import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The four things a user can start from the dashboard.
enum QuickAction {
  buy(Icons.add_rounded, 'Buy'),
  sell(Icons.remove_rounded, 'Sell'),
  send(Icons.north_east_rounded, 'Send'),
  receive(Icons.south_west_rounded, 'Receive');

  const QuickAction(this.icon, this.label);

  final IconData icon;
  final String label;
}

/// The row of four action chips under the hero card.
class QuickActions extends StatelessWidget {
  const QuickActions({required this.onSelected, super.key});

  final ValueChanged<QuickAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final action in QuickAction.values) ...<Widget>[
          if (action != QuickAction.values.first)
            const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: _ActionChip(
              action: action,
              onTap: () => onSelected(action),
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.action, required this.onTap});

  final QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Buy is the primary path, so its glyph carries the accent.
    final tint = action == QuickAction.buy
        ? AppColors.accent
        : AppColors.icon;

    return Semantics(
      button: true,
      label: action.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Icon(action.icon, size: 20, color: tint),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              action.label,
              style: AppTextStyles.subtleBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
