import '../../../core/utils/result.dart';
import 'entities/user_profile.dart';

/// Read access to the signed-in user's profile.
abstract interface class ProfileRepository {
  Future<Result<UserProfile>> loadProfile();
}
