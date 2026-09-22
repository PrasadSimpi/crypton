import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/mock_auth_repository.dart';
import '../../domain/auth_repository.dart';
import '../../domain/entities/auth_user.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const MockAuthRepository(),
);

/// The current session. `AsyncData(null)` means signed out, which is a settled
/// state - distinct from `AsyncLoading`, which means a sign-in is in flight.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);

final class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  AuthUser? build() => null;

  /// Returns true when a session was established, so the caller can navigate.
  /// A false return leaves the failure in [state] for the form to render.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue<AuthUser?>.loading();
    state = await AsyncValue.guard<AuthUser?>(
      () async => (await ref
              .read(authRepositoryProvider)
              .signIn(email: email, password: password))
          .unwrap(),
    );
    return !state.hasError && state.value != null;
  }

  /// Enter the app without an account.
  Future<void> continueAsGuest() async {
    state = const AsyncValue<AuthUser?>.loading();
    state = await AsyncValue.guard<AuthUser?>(
      () async =>
          (await ref.read(authRepositoryProvider).continueAsGuest()).unwrap(),
    );
  }

  void signOut() => state = const AsyncValue<AuthUser?>.data(null);
}
