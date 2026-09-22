import 'package:flutter/painting.dart';

/// The Crypton palette, ported 1:1 from the `:root` custom properties in the
/// HTML UI reference.
///
/// This file is the only place in the app allowed to hold a colour literal.
/// Widgets normally read `Theme.of(context).colorScheme`; these constants cover
/// the brand slots Material's [ColorScheme] has no name for - the three border
/// elevations, chart ink, and the per-coin identity tints.
abstract final class AppColors {
  // --- Surfaces -------------------------------------------------------------

  /// Scaffold background.
  static const Color bg = Color(0xFF0A0B0D);

  /// Cards and list rows.
  static const Color surface = Color(0xFF111317);

  /// Raised: the floating nav pill, quick-action chips.
  static const Color surfaceRaised = Color(0xFF17191E);

  /// Settings-row icon chips.
  static const Color surfaceChip = Color(0xFF1B1E23);

  /// Text fields and circular icon buttons.
  static const Color surfaceField = Color(0xFF14161A);

  // --- Borders --------------------------------------------------------------

  /// Card borders.
  static const Color border = Color(0xFF1D2025);

  /// Inputs and icon buttons.
  static const Color borderStrong = Color(0xFF262A30);

  /// The floating nav pill.
  static const Color borderNav = Color(0xFF2A2E35);

  /// Hairline inside a card.
  static const Color divider = Color(0xFF23262B);

  // --- Brand ----------------------------------------------------------------

  static const Color accent = Color(0xFFF2A93B);
  static const Color accentLight = Color(0xFFFFC46B);
  static const Color accentDeep = Color(0xFFC97F1F);

  /// Ink on top of an amber surface.
  static const Color onAccent = bg;

  // --- Semantic -------------------------------------------------------------

  /// Gains, up candles.
  static const Color up = Color(0xFF34C77B);

  /// Gains sitting on a dark pill, where [up] would be too dim.
  static const Color upSoft = Color(0xFF5BDD9C);

  /// Down candles.
  static const Color down = Color(0xFFF2555A);

  /// Losses as text - lighter than [down] so it clears 4.5:1 on [bg].
  static const Color downText = Color(0xFFFF7A7E);

  // --- Text and icons -------------------------------------------------------

  static const Color textPrimary = Color(0xFFF6F4F0);
  static const Color textSecondary = Color(0xFFA2A8B0);

  /// Labels and captions - the lowest step that still passes 4.5:1.
  static const Color textTertiary = Color(0xFF868D96);

  /// Axis ticks only: non-essential text held to the 3:1 graphic bar.
  static const Color textQuaternary = Color(0xFF6C727A);

  static const Color icon = Color(0xFFD8DCE2);

  // --- Coin identity tints --------------------------------------------------
  // Invented hues for legibility against this palette, not brand logos.

  static const Color btc = Color(0xFFF2A93B);
  static const Color eth = Color(0xFF9AA6FF);
  static const Color sol = Color(0xFF3FD3CE);
  static const Color xrp = Color(0xFFB4BECB);

  /// Fallback so an asset we have no tint for still renders a legible chip.
  static const Color coinNeutral = Color(0xFFB4BECB);

  /// Identity colour for [symbol].
  static Color coinAccent(String symbol) => switch (symbol.toUpperCase()) {
    'BTC' => btc,
    'ETH' => eth,
    'SOL' => sol,
    'XRP' => xrp,
    _ => coinNeutral,
  };

  /// The 14% wash of [coinAccent] that sits behind a coin monogram.
  static Color coinSurface(String symbol) =>
      coinAccent(symbol).withValues(alpha: 0.14);
}
