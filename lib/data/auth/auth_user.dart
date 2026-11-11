enum UserRole {
  admin(1),
  normal(2),
  superadmin(3);

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
    this.image,
    this.createdAt,
    this.emailVerified = false,
  });

  final String id;
  final String email;
  final UserRole role;
  final String? name;
  final String? image;
  final DateTime? createdAt;
  final bool emailVerified;

  /// Returns null when the backend sends a role this app doesn't know.
  static AuthUser? tryFromJson(Map<String, dynamic> json) {
    final role = UserRole.fromId((json['roleId'] as num?)?.toInt());
    if (role == null) return null;

    final createdAt = json['createdAt'];
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      role: role,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt: createdAt is String ? DateTime.tryParse(createdAt) : null,
    );
  }

  AuthUser copyWith({String? name, String? image}) => AuthUser(
    id: id,
    email: email,
    role: role,
    name: name ?? this.name,
    image: image ?? this.image,
    createdAt: createdAt,
    emailVerified: emailVerified,
  );
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

  AuthSession copyWith({AuthUser? user}) => AuthSession(
    user: user ?? this.user,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
