/// Everything that can go wrong below the presentation layer, as a closed set.
///
/// Repositories return a [Failure] inside a `Result`; they do not throw across
/// a layer boundary. Each carries copy that is safe to show a user as-is.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// User-facing, already written in plain language.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The device could not reach the service.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No connection. Check your network and try again.',
  ]);
}

/// The service answered, but with something unusable.
final class DataFailure extends Failure {
  const DataFailure([
    super.message = 'We could not load this right now. Pull to retry.',
  ]);
}

/// Credentials were rejected.
final class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Those details did not match an account.',
  ]);
}

/// The asset, holding or record asked for does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'We could not find that asset.']);
}

/// Anything uncategorised - always worth logging.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
