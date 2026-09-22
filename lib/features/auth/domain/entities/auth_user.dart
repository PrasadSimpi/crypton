/// Who is signed in.
final class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.isGuest = false,
  });

  /// Someone who tapped Skip: the app runs read-only over the mock book.
  const AuthUser.guest()
    : id = 'guest',
      name = 'Guest',
      email = '',
      isGuest = true;

  final String id;
  final String name;
  final String email;
  final bool isGuest;

  /// First letter of the display name, for the avatar.
  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}
