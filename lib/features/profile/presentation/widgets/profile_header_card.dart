import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../domain/entities/user_profile.dart';

/// Avatar, name, email and verification status.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: <Widget>[
          UserAvatar(initial: profile.initial, size: 64),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.name,
                  style: AppTextStyles.titleLarge.copyWith(
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                Text(
                  profile.email,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (profile.isVerified) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs + 2),
                  _VerifiedChip(tier: profile.verificationTier),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.tier});

  final int tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: AppColors.up.withValues(alpha: 0.13),
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.up.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.check_rounded, size: 11, color: AppColors.up),
          const SizedBox(width: 5),
          Text(
            'VERIFIED - TIER $tier',
            style: AppTextStyles.tiny.copyWith(
              fontSize: 10,
              letterSpacing: 0.4,
              color: AppColors.up,
            ),
          ),
        ],
      ),
    );
  }
}
