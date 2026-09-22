import '../../../core/utils/result.dart';
import '../domain/entities/user_profile.dart';
import '../domain/profile_repository.dart';

/// The demo account from the design reference.
final class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository({
    this.latency = const Duration(milliseconds: 380),
  });

  final Duration latency;

  @override
  Future<Result<UserProfile>> loadProfile() async {
    await Future<void>.delayed(latency);
    return Ok(
      UserProfile(
        name: 'Alex Rivera',
        email: 'alex@crypton.io',
        memberSince: DateTime(2024, 1),
        tradeCount: 148,
        assetsHeld: 4,
        verificationTier: 2,
        isVerified: true,
        linkedPaymentMethods: 2,
        displayCurrency: 'USD',
      ),
    );
  }
}
