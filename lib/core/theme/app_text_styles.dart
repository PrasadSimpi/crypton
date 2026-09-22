import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// The two bundled families. Both ship as static TTFs under `assets/fonts/`,
/// so the app renders identically offline and never flashes a fallback face -
/// which matters when the screens are being screen-recorded.
abstract final class AppFonts {
  /// Numerals, balances, prices, headings.
  static const String display = 'SpaceGrotesk';

  /// Labels, body copy, buttons.
  static const String body = 'Manrope';
}

/// Every text style in the app. Sizes and letter-spacings are lifted from the
/// HTML reference; no widget declares a `fontSize` of its own.
///
/// Styles carry their most common colour so call sites stay short; override
/// with `.copyWith(color: ...)` when a row needs a semantic colour instead.
abstract final class AppTextStyles {
  // --- Display family: numbers and headings ---------------------------------

  /// The amber hero card's balance.
  static const TextStyle heroBalance = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.8,
    height: 1,
    color: AppColors.onAccent,
  );

  /// The cents on [heroBalance].
  static const TextStyle heroBalanceFraction = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1,
    color: AppColors.onAccent,
  );

  /// Asset-detail last price.
  static const TextStyle price = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.4,
    height: 1,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceFraction = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1,
    color: AppColors.textSecondary,
  );

  /// Big card metrics: current value, total invested.
  static const TextStyle metric = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 27,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    height: 1,
    color: AppColors.textPrimary,
  );

  static const TextStyle metricFraction = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.textSecondary,
  );

  /// All-time profit.
  static const TextStyle profit = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1,
    color: AppColors.up,
  );

  /// "Welcome back".
  static const TextStyle headline = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  /// App-bar titles, profile name.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Section headers.
  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Card sub-heading, e.g. "Allocation".
  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Profile stat tiles.
  static const TextStyle numeralLarge = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// List-row price.
  static const TextStyle numeral = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Stat-tile value.
  static const TextStyle numeralSmall = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Row delta, legend entries.
  static const TextStyle numeralTiny = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Holding sub-line: "0.4215 - avg $44,839.86".
  static const TextStyle numeralMono = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );

  /// Timeframe chips.
  static const TextStyle tab = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
  );

  /// Chart axis ticks.
  static const TextStyle axis = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 9.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textQuaternary,
  );

  /// The amber live-price tag on the chart.
  static const TextStyle priceTag = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.onAccent,
  );

  /// The splash wordmark. Letter-spacing is animated at the call site.
  static const TextStyle wordmark = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 27,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.textPrimary,
  );

  // --- Body family: copy, labels, buttons -----------------------------------

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: AppColors.textSecondary,
  );

  /// List-row primary line.
  static const TextStyle rowTitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Settings-row label.
  static const TextStyle settingTitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.icon,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
  );

  /// Row secondary line, quick-action labels.
  static const TextStyle subtle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );

  static const TextStyle subtleBold = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// All-caps field and metric labels.
  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.3,
    color: AppColors.textTertiary,
  );

  /// All-caps section eyebrow.
  static const TextStyle eyebrow = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 10.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.3,
    color: AppColors.textTertiary,
  );

  /// The tightest all-caps label: mini-card keys, profile tile captions.
  static const TextStyle tiny = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    color: AppColors.textTertiary,
  );

  /// "SECURING SESSION" under the splash progress bar.
  static const TextStyle splashCaption = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.6,
    color: AppColors.textQuaternary,
  );

  /// Inline accent links: "See all", "Forgot password?".
  static const TextStyle link = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
}
