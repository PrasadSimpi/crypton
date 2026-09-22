import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// A labelled 56-tall input (`.field` + `.input`), with an optional reveal
/// toggle for passwords.
///
/// Errors are announced with an icon and a message as well as a red border, so
/// the state never rests on colour alone.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.onSubmitted,
    this.autofillHints,
  });

  /// All-caps label above the field.
  final String label;

  final TextEditingController controller;
  final String? hintText;

  /// Starts obscured and shows a reveal button.
  final bool obscure;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final error = widget.errorText;
    final hasError = error != null && error.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.label, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: widget.controller,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          autofillHints: widget.autofillHints,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 15,
            height: 1.2,
          ),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.surfaceField,
            hintText: widget.hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textTertiary,
              fontSize: 15,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            border: _border(AppColors.borderStrong),
            enabledBorder: _border(
              hasError ? AppColors.down : AppColors.borderStrong,
            ),
            focusedBorder: _border(
              hasError ? AppColors.down : AppColors.accentLight,
              width: 2,
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                    tooltip: _hidden ? 'Show password' : 'Hide password',
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: AppSpacing.minTapTarget,
              minHeight: AppSpacing.minTapTarget,
            ),
          ),
        ),
        if (hasError) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.error_outline_rounded,
                size: 15,
                color: AppColors.downText,
              ),
              const SizedBox(width: AppSpacing.xs + 2),
              Expanded(
                child: Text(
                  error,
                  style: AppTextStyles.subtle.copyWith(
                    color: AppColors.downText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  static OutlineInputBorder _border(Color colour, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: AppRadii.sm,
        borderSide: BorderSide(color: colour, width: width),
      );
}
