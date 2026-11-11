import 'package:dio/dio.dart';

import '../../core/failure.dart';
import '../../core/token_storage.dart';
import '../../core/api_guard.dart';
import '../../core/util/result.dart';
import '../../services/auth_services.dart';
import 'auth_repository.dart';
import 'auth_user.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio, this._tokenStorage, this._google);

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final GoogleAuthService _google;

  @override
  Future<Result<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) => _signIn('/api/auth/sign-in/email', {
    'email': email,
    'password': password,
  });

  @override
  Future<Result<AuthSession>> signInWithGoogle() async {
    try {
      final idToken = await _google.getIdToken();
      return await _signIn('/api/auth/sign-in/social', {
        'provider': 'google',
        'idToken': {'token': idToken},
      });
    } on Failure catch (f) {
      return Err(f);
    } catch (_) {
      return const Err(ServerFailure());
    }
  }

  /// Shared by email and Google sign-in: both return {user, token?} and the
  /// bearer plugin also sends the token in the `set-auth-token` header.
  Future<Result<AuthSession>> _signIn(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: data);
      final body = res.data!;
      final user = body['user'] as Map<String, dynamic>;

      final token =
          res.headers.value('set-auth-token') ?? body['token'] as String?;
      if (token == null) return const Err(ServerFailure());

      final role = UserRole.fromId((user['roleId'] as num?)?.toInt());
      if (role == null) return const Err(ForbiddenFailure());

      await _tokenStorage.save(accessToken: token);

      return Success(
        AuthSession(
          user: AuthUser(
            id: user['id'] as String,
            email: user['email'] as String,
            name: user['name'] as String?,
            role: role,
            emailVerified: user['emailVerified'] as bool? ?? false,
          ),
          accessToken: token,
        ),
      );
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } catch (_) {
      return const Err(ServerFailure());
    }
  }

  @override
  Future<Result<void>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) => _post('/api/auth/sign-up/email', {
    'name': name,
    'email': email,
    'password': password,
  });

  @override
  Future<Result<void>> resendVerificationEmail({required String email}) =>
      _post('/api/auth/send-verification-email', {'email': email});

  @override
  Future<Result<void>> sendPasswordReset({required String email}) =>
      _post('/api/auth/request-password-reset', {'email': email});

  @override
  Future<Result<void>> signOut() async {
    try {
      await _dio.post<void>('/api/auth/sign-out');
    } on DioException catch (_) {}
    await _google.signOut();
    await _tokenStorage.clear();
    return const Success(null);
  }

  Future<Result<void>> _post(String path, Map<String, dynamic> data) async {
    try {
      await _dio.post<void>(path, data: data);
      return const Success(null);
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } catch (_) {
      return const Err(ServerFailure());
    }
  }

  Failure mapDioError(Exception e) => mapDioError(e);
}
