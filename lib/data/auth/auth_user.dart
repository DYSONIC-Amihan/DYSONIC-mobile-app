enum UserRole {
  admin(1, 'Administrator'),
  normal(2, 'Member');

  const UserRole(this.id, this.label);
  final int id;
  final String label;

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

  /// Name if set, otherwise the email.
  String get displayName {
    final trimmed = name?.trim();
    return (trimmed == null || trimmed.isEmpty) ? email : trimmed;
  }

  /// Up to two uppercase initials, e.g. "Juan Dela Cruz" -> "JD".
  String get initials {
    final parts = displayName
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
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