/// The account card and settings rows on the profile screen.
final class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.memberSince,
    required this.tradeCount,
    required this.assetsHeld,
    required this.verificationTier,
    required this.isVerified,
    required this.linkedPaymentMethods,
    required this.displayCurrency,
  });

  final String name;
  final String email;

  /// Rendered as `Jan 2024`.
  final DateTime memberSince;

  final int tradeCount;
  final int assetsHeld;

  /// KYC tier, 0 when unverified.
  final int verificationTier;

  final bool isVerified;
  final int linkedPaymentMethods;

  /// ISO code shown on the Display currency row.
  final String displayCurrency;

  /// First letter of the display name, for the avatar.
  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}

/// The two switches on the profile screen.
final class ProfileSettings {
  const ProfileSettings({
    this.twoFactorEnabled = true,
    this.priceAlertsEnabled = true,
  });

  final bool twoFactorEnabled;
  final bool priceAlertsEnabled;

  ProfileSettings copyWith({bool? twoFactorEnabled, bool? priceAlertsEnabled}) =>
      ProfileSettings(
        twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
        priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      );
}
