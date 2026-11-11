import '../../core/failure.dart';
import '../../core/util/result.dart';
import '../auth/auth_user.dart';
import 'account_repository.dart';
import 'avatar_option.dart';

class MockAccountRepository implements AccountRepository {
  MockAccountRepository(this._readUser);

  final AuthUser? Function() _readUser;

  // Placeholder URLs: the avatar widget falls back to initials if they fail.
  static const _avatars = [
    AvatarOption(id: 'pedro-glasses', url: 'https://example.com/a/1.png'),
    AvatarOption(id: 'pedro-tlou', url: 'https://example.com/a/2.png'),
    AvatarOption(id: 'shawn-hat', url: 'https://example.com/a/3.png'),
  ];

  Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 600));

  Future<Result<AuthUser>> _withUser(AuthUser Function(AuthUser) map) async {
    await _latency();
    final user = _readUser();
    if (user == null) return const Err(UnauthorizedFailure());
    return Success(map(user));
  }

  @override
  Future<Result<AuthUser>> fetchMe() => _withUser((u) => u);

  @override
  Future<Result<AuthUser>> updateName(String name) =>
      _withUser((u) => u.copyWith(name: name));

  @override
  Future<Result<List<AvatarOption>>> fetchAvatars() async {
    await _latency();
    return const Success(_avatars);
  }

  @override
  Future<Result<String>> updateAvatar(String avatarId) async {
    await _latency();
    for (final a in _avatars) {
      if (a.id == avatarId) return Success(a.url);
    }
    return const Err(ValidationFailure('Unknown avatar id'));
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _latency();
    if (currentPassword == 'wrongpass') {
      return const Err(ValidationFailure('Invalid password'));
    }
    return const Success(null);
  }
}
