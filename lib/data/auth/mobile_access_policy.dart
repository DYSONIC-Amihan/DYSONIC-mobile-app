import 'auth_user.dart';

abstract final class MobileAccessPolicy {
  static const allowedRoles = {UserRole.normal};

  static bool isAllowed(AuthUser user) => allowedRoles.contains(user.role);
}
