import 'package:flutter/painting.dart';

/// The 8px spacing scale from the UI reference (`--s1` ... `--s7`).
///
/// Every `EdgeInsets`, `SizedBox` and gap in the app comes from here. A one-off
/// value such as `EdgeInsets.only(left: 13)` is a bug, not a nuance.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Horizontal page gutter - the `.phone` padding in the reference.
  static const double gutter = 20;

  /// Card interior. Off the 4px scale at 18, but it is what the reference uses
  /// for every `.card`, so it is named here rather than sprinkled as a literal.
  static const double card = 18;

  /// Interior of the small stat and mini tiles.
  static const double tile = 14;

  /// Vertical room a scrolling screen must leave free so its last row is not
  /// swallowed by the floating nav pill (64 tall + 26 from the bottom + air).
  static const double navReserve = 118;

  /// Room reserved by the Buy/Sell bar on the asset-detail screen.
  static const double actionBarReserve = 108;

  /// Smallest tap target we ship. The reference keeps everything at 44; Material
  /// asks for 48, so interactive widgets pad out to this while the painted
  /// shape stays 44.
  static const double minTapTarget = 48;
}

/// Corner radii (`--r-sm` ... `--r-pill`).
abstract final class AppRadius {
  static const double sm = 14;
  static const double md = 18;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 28;
  static const double pill = 999;
}

/// Ready-made [BorderRadius] values, so widgets never build one from a number.
abstract final class AppRadii {
  static const BorderRadius sm = BorderRadius.all(Radius.circular(AppRadius.sm));
  static const BorderRadius md = BorderRadius.all(Radius.circular(AppRadius.md));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(AppRadius.lg));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(AppRadius.xl));
  static const BorderRadius xxl =
      BorderRadius.all(Radius.circular(AppRadius.xxl));
  static const BorderRadius pill =
      BorderRadius.all(Radius.circular(AppRadius.pill));
}
