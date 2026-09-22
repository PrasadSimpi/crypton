import '../errors/failure.dart';

/// A value or a [Failure] - never an exception crossing a layer boundary.
///
/// Exhaustive by construction, so a `switch` over it needs no default branch:
///
/// ```dart
/// final message = switch (await repository.loadPortfolio()) {
///   Ok(:final value) => value.formattedTotal,
///   Err(:final failure) => failure.message,
/// };
/// ```
sealed class Result<T> {
  const Result();

  /// True when this is an [Ok].
  bool get isOk => this is Ok<T>;

  /// The value when this is an [Ok], otherwise null.
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };
}

/// A successful result carrying [value].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// A failed result carrying [failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}

extension ResultX<T> on Result<T> {
  /// The value, or the [Failure] rethrown.
  ///
  /// This is the one sanctioned place a [Failure] becomes a throw: inside a
  /// Riverpod provider, where the throw is caught by the framework and handed
  /// to the UI as `AsyncValue.error`. Nothing below the provider layer calls it.
  T unwrap() => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>(:final failure) => throw failure,
  };
}
