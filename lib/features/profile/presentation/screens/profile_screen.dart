import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/async_view.dart';
import '../../../../shared/widgets/page_column.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/user_profile.dart';
import '../controllers/profile_providers.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/settings_group.dart';

/// Profile and settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final settings = ref.watch(profileSettingsProvider);
    final settingsController = ref.read(profileSettingsProvider.notifier);

    return RefreshIndicator(
      onRefresh: ref.read(profileProvider.notifier).refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          bottom: false,
          child: PageColumn(
            children: <Widget>[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  AppIconButton(
                    icon: Icons.chevron_left_rounded,
                    semanticLabel: 'Back',
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  Expanded(
                    child: Text(
                      'Profile',
                      style: AppTextStyles.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    semanticLabel: 'Edit profile',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.card),
              AsyncView<UserProfile>(
                value: profile,
                loadingHeight: 200,
                onRetry: ref.read(profileProvider.notifier).refresh,
                builder: (UserProfile data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ProfileHeaderCard(profile: data),
                    const SizedBox(height: AppSpacing.md),
                    ProfileStatsRow(profile: data),
                    const SizedBox(height: AppSpacing.xl),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('ACCOUNT', style: AppTextStyles.eyebrow),
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SettingsGroup(
                      children: <Widget>[
                        SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal details',
                          onTap: () {},
                        ),
                        SettingsTile(
                          icon: Icons.credit_card_rounded,
                          title: 'Payment methods',
                          meta: '${data.linkedPaymentMethods} linked',
                          onTap: () {},
                        ),
                        SettingsTile(
                          icon: Icons.verified_user_outlined,
                          title: 'Identity verification',
                          meta: data.isVerified ? 'Complete' : 'Pending',
                          metaIsPositive: data.isVerified,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.card),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SECURITY & PREFERENCES',
                        style: AppTextStyles.eyebrow,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SettingsGroup(
                      children: <Widget>[
                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Two-factor authentication',
                          trailing: Switch.adaptive(
                            value: settings.twoFactorEnabled,
                            onChanged: (bool value) => settingsController
                                .setTwoFactor(enabled: value),
                          ),
                        ),
                        SettingsTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Price alerts',
                          trailing: Switch.adaptive(
                            value: settings.priceAlertsEnabled,
                            onChanged: (bool value) => settingsController
                                .setPriceAlerts(enabled: value),
                          ),
                        ),
                        SettingsTile(
                          icon: Icons.language_rounded,
                          title: 'Display currency',
                          meta: data.displayCurrency,
                          onTap: () {},
                        ),
                        SettingsTile(
                          icon: Icons.logout_rounded,
                          title: 'Log out',
                          isDestructive: true,
                          onTap: () => _signOut(context, ref),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.navReserve),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirms before ending the session - signing out is the one destructive
  /// action on this screen.
  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to trade.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    ref.read(authControllerProvider.notifier).signOut();
    context.go(AppRoutes.signIn);
  }
}
