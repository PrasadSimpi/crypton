import '../../../core/utils/result.dart';
import 'entities/auth_user.dart';

/// Sign-in surface.
///
/// The mock implementation accepts any well-formed input; a real one would swap
/// in behind this same interface without the UI changing.
abstract interface class AuthRepository {
  /// Exchange credentials for a session.
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  });

  /// Enter the app without an account.
  Future<Result<AuthUser>> continueAsGuest();
}
