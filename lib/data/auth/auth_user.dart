enum UserRole {
  admin(1),
  normal(2);

  const UserRole(this.id);
  final int id;

  static UserRole? fromId(int? id) {
    for (final role in values) {
      if (role.id == id) return role;
    }
    return null;
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.emailVerified = false,
  });

  final String id;
  final String email;
  final UserRole role;
  final String? name;
  final bool emailVerified;
}

class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  final AuthUser user;
  final String accessToken;
  final String? refreshToken;
}
