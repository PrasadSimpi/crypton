import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/mock_profile_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => const MockProfileRepository(),
);

final profileProvider =
    AsyncNotifierProvider<ProfileController, UserProfile>(
      ProfileController.new,
    );

final class ProfileController extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async =>
      (await ref.watch(profileRepositoryProvider).loadProfile()).unwrap();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async =>
          (await ref.read(profileRepositoryProvider).loadProfile()).unwrap(),
    );
  }
}

/// The two switches on the profile screen. Local and in-memory: this build has
/// no settings backend, and the Ledger records that as known debt.
final profileSettingsProvider =
    NotifierProvider<ProfileSettingsController, ProfileSettings>(
      ProfileSettingsController.new,
    );

final class ProfileSettingsController extends Notifier<ProfileSettings> {
  @override
  ProfileSettings build() => const ProfileSettings();

  void setTwoFactor({required bool enabled}) =>
      state = state.copyWith(twoFactorEnabled: enabled);

  void setPriceAlerts({required bool enabled}) =>
      state = state.copyWith(priceAlertsEnabled: enabled);
}
