import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failure.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_button.dart';

/// Renders the three states of an [AsyncValue] so no screen has to spell them
/// out: loading, error with a retry, and data - plus an optional empty state.
///
/// Intended for a non-nullable `T`; a null value is read as "not loaded yet".
/// While a refresh is in flight over data we already have, the old data stays
/// on screen rather than flashing back to a spinner.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    required this.value,
    required this.builder,
    super.key,
    this.onRetry,
    this.loadingHeight = 200,
    this.isEmpty,
    this.emptyMessage = 'Nothing here yet.',
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  /// Shown on the error state's button. Omit it and the button is hidden.
  final Future<void> Function()? onRetry;

  /// Reserved height for the spinner, so the layout does not jump when data
  /// arrives.
  final double loadingHeight;

  /// Tells this view when [T] should be treated as empty.
  final bool Function(T data)? isEmpty;

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final data = value.value;

    if (data != null) {
      if (isEmpty?.call(data) ?? false) {
        return _EmptyState(message: emptyMessage, height: loadingHeight);
      }
      return builder(data);
    }

    if (value.hasError) {
      return _ErrorState(
        message: _messageFor(value.error),
        onRetry: onRetry,
        height: loadingHeight,
      );
    }

    return _LoadingState(height: loadingHeight);
  }

  /// Failures already carry copy fit to show a user; anything else gets a
  /// neutral line rather than a stack trace.
  static String _messageFor(Object? error) =>
      error is Failure ? error.message : 'Something went wrong.';
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: SizedBox.square(
          dimension: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.height,
  });

  final String message;
  final Future<void> Function()? onRetry;
  final double height;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // The icon carries the state as well as the colour does.
              const Icon(
                Icons.error_outline_rounded,
                size: 28,
                color: AppColors.downText,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              if (retry != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: 168,
                  child: AppButton(
                    label: 'Try again',
                    variant: AppButtonVariant.outline,
                    onPressed: () => retry().ignore(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.height});

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(message, style: AppTextStyles.body),
      ),
    );
  }
}
