import '../../../core/errors/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/auth_user.dart';

/// Accepts any syntactically valid email with a password of six or more
/// characters, and rejects everything else - enough to exercise the form's
/// error path without pretending to be an identity provider.
final class MockAuthRepository implements AuthRepository {
  const MockAuthRepository({
    this.latency = const Duration(milliseconds: 900),
  });

  final Duration latency;

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);

    if (!_email.hasMatch(email.trim())) {
      return const Err(AuthFailure('That email address does not look right.'));
    }
    if (password.length < 6) {
      return const Err(
        AuthFailure('Passwords are at least six characters long.'),
      );
    }

    return Ok(
      AuthUser(
        id: 'mock-user',
        name: _nameFrom(email),
        email: email.trim(),
      ),
    );
  }

  @override
  Future<Result<AuthUser>> continueAsGuest() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return const Ok(AuthUser.guest());
  }

  /// `alex@crypton.io` becomes `Alex Rivera` for the demo account, and a
  /// title-cased local part for anything else.
  static String _nameFrom(String email) {
    final local = email.trim().split('@').first;
    if (local.toLowerCase() == 'alex') return 'Alex Rivera';
    if (local.isEmpty) return 'Trader';
    return local[0].toUpperCase() + local.substring(1);
  }
}
