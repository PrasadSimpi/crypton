import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Assembles [ThemeData] from the token files.
///
/// Crypton ships dark-only by product decision - the reference is amber on
/// near-black and a light inversion would be a different design, not a tint.
/// The structure here is still theme-driven, so adding a light scheme later is
/// a matter of writing one more [ColorScheme] and flipping `themeMode`.
abstract final class AppTheme {
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.accent,
    onPrimary: AppColors.onAccent,
    primaryContainer: AppColors.accentDeep,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.accentLight,
    onSecondary: AppColors.onAccent,
    tertiary: AppColors.up,
    onTertiary: AppColors.onAccent,
    error: AppColors.down,
    onError: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: AppColors.bg,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.surfaceChip,
    surfaceContainerHigh: AppColors.surfaceRaised,
    surfaceContainerHighest: AppColors.surfaceRaised,
    outline: AppColors.border,
    outlineVariant: AppColors.borderStrong,
  );

  /// Status-bar / nav-bar styling for the dark scheme.
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.bg,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static ThemeData get dark {
    const scheme = _darkScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      canvasColor: AppColors.bg,
      fontFamily: AppFonts.body,
      dividerColor: AppColors.divider,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: AppColors.accent.withValues(alpha: 0.08),
      highlightColor: AppColors.accent.withValues(alpha: 0.05),
      iconTheme: const IconThemeData(color: AppColors.icon, size: 20),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionHandleColor: AppColors.accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge,
        systemOverlayStyle: overlayStyle,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.bg
              : AppColors.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accent
              : AppColors.surfaceChip,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : AppColors.borderStrong,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surfaceRaised,
        contentTextStyle: AppTextStyles.settingTitle,
        behavior: SnackBarBehavior.floating,
        insetPadding: EdgeInsets.all(AppSpacing.lg),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.heroBalance,
        headlineLarge: AppTextStyles.headline,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.label,
        labelSmall: AppTextStyles.eyebrow,
      ),
    );
  }
}
