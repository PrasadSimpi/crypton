import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/user_profile.dart';

/// Member since, trades, assets held.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final tiles = <({String value, String label})>[
      (value: Formatters.monthYear(profile.memberSince), label: 'MEMBER SINCE'),
      (value: '${profile.tradeCount}', label: 'TRADES'),
      (value: '${profile.assetsHeld}', label: 'ASSETS HELD'),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (var i = 0; i < tiles.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: _StatTile(value: tiles[i].value, label: tiles[i].label),
          ),
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: AppTextStyles.numeralLarge),
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.tiny.copyWith(letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
