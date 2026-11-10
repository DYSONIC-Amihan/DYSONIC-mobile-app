import '../../core/util/result.dart';
import '../auth/auth_user.dart';
import 'avatar_option.dart';

abstract interface class AccountRepository {
  Future<Result<AuthUser>> fetchMe();

  Future<Result<AuthUser>> updateName(String name);

  Future<Result<List<AvatarOption>>> fetchAvatars();

  /// Returns the new image URL.
  Future<Result<String>> updateAvatar(String avatarId);

  /// The backend revokes other sessions and returns a fresh token for this
  /// one; implementations must persist it.
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
