import 'package:dio/dio.dart';

import '../../core/api_guard.dart';
import '../../core/failure.dart';
import '../../core/token_storage.dart';
import '../../core/util/result.dart';
import '../auth/auth_user.dart';
import 'account_repository.dart';
import 'avatar_option.dart';

class ApiAccountRepository implements AccountRepository {
  ApiAccountRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  static const _base = '/api/account';

  @override
  Future<Result<AuthUser>> fetchMe() => guardApi(() async {
    final res = await _dio.get<Map<String, dynamic>>('$_base/me');
    return _parseUser(res.data);
  });

  @override
  Future<Result<AuthUser>> updateName(String name) => guardApi(() async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '$_base/me',
      data: {'name': name},
    );
    return _parseUser(res.data);
  });

  @override
  Future<Result<List<AvatarOption>>> fetchAvatars() => guardApi(() async {
    final res = await _dio.get<Map<String, dynamic>>('$_base/avatars');
    final items = res.data?['avatars'] as List<dynamic>? ?? const [];
    return [
      for (final item in items)
        AvatarOption.fromJson(item as Map<String, dynamic>),
    ];
  });

  @override
  Future<Result<String>> updateAvatar(String avatarId) => guardApi(() async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '$_base/avatar',
      data: {'avatarId': avatarId},
    );
    final image = res.data?['image'];
    if (image is! String) throw const ServerFailure();
    return image;
  });

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => guardApi(() async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '$_base/password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
    final token = res.data?['token'];
    if (token is String) await _tokenStorage.save(accessToken: token);
  });

  AuthUser _parseUser(Map<String, dynamic>? json) {
    final user = json == null ? null : AuthUser.tryFromJson(json);
    if (user == null) throw const ServerFailure();
    return user;
  }
}
