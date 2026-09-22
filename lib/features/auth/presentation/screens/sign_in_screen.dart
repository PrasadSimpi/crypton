import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/accent_bloom.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/crypton_lockup.dart';
import '../widgets/or_divider.dart';
import '../widgets/skip_button.dart';

/// Sign in, or skip straight into the app as a guest.
///
/// The form is prefilled with the demo account so the screen can be recorded
/// without typing; any address that parses and a password of six or more
/// characters is accepted by the mock repository.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _email = TextEditingController(
    text: 'alex@crypton.io',
  );
  final TextEditingController _password = TextEditingController(
    text: 'crypt0ndemo',
  );

  bool _skipping = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final succeeded = await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _email.text, password: _password.text);
    if (!mounted || !succeeded) return;
    context.go(AppRoutes.home);
  }

  Future<void> _skip() async {
    setState(() => _skipping = true);
    await ref.read(authControllerProvider.notifier).continueAsGuest();
    if (!mounted) return;
    setState(() => _skipping = false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isSubmitting = auth.isLoading && !_skipping;
    final error = auth.hasError ? _errorMessage(auth.error) : null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      // resizeToAvoidBottomInset plus a scroll view keeps the form reachable
      // once the keyboard is up, on any screen height.
      body: Stack(
        children: <Widget>[
          const Positioned(
            right: -120,
            top: -140,
            child: AccentBloom(diameter: 380, opacity: 0.13),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.gutter,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      // The form is a reading column, not a stretch target: it
                      // stays narrow and centred on a tablet.
                      maxWidth: 520,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: AppSpacing.minTapTarget,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const CryptonLockup(),
                              SkipButton(
                                isBusy: _skipping,
                                onPressed: isSubmitting ? null : _skip,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 44),
                        Text('Welcome back', style: AppTextStyles.headline),
                        const SizedBox(height: AppSpacing.md),
                        const SizedBox(
                          width: 290,
                          child: Text(
                            'Sign in to pick up where your portfolio left off '
                            '- or skip ahead and browse the markets first.',
                            style: AppTextStyles.body,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl + 4),
                        AppTextField(
                          label: 'EMAIL',
                          controller: _email,
                          hintText: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const <String>[AutofillHints.email],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppTextField(
                          label: 'PASSWORD',
                          controller: _password,
                          hintText: 'Your password',
                          obscure: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const <String>[
                            AutofillHints.password,
                          ],
                          onSubmitted: (_) => _signIn(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.link,
                            ),
                          ),
                        ),
                        if (error != null) ...<Widget>[
                          const SizedBox(height: AppSpacing.sm),
                          _FormError(message: error),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        AppButton(
                          label: 'Log in',
                          isLoading: isSubmitting,
                          onPressed: _skipping ? null : _signIn,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        const OrDivider(label: 'OR CONTINUE WITH'),
                        const SizedBox(height: AppSpacing.xl),
                        const Row(
                          children: <Widget>[
                            Expanded(
                              child: AppButton(
                                label: 'Google',
                                variant: AppButtonVariant.subtle,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: AppButton(
                                label: 'Apple',
                                variant: AppButtonVariant.subtle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Text(
                                'New to Crypton? ',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Create an account',
                                  style: AppTextStyles.link,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Failures already carry copy fit to show a user; anything else gets a
  /// neutral line rather than a stack trace.
  static String _errorMessage(Object? error) =>
      error is Failure ? error.message : 'We could not sign you in.';
}

/// Sign-in failure, shown with an icon so the state is not carried by the red
/// alone.
class _FormError extends StatelessWidget {
  const _FormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.down.withValues(alpha: 0.10),
        borderRadius: AppRadii.sm,
        border: Border.all(color: AppColors.down.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.error_outline_rounded,
            size: 17,
            color: AppColors.downText,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.subtle.copyWith(
                color: AppColors.downText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
