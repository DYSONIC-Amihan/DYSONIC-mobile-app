import 'package:dio/dio.dart';

import '../../core/failure.dart';
import '../../core/token_storage.dart';
import '../../core/util/result.dart';
import 'auth_repository.dart';
import 'auth_user.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  @override
  Future<Result<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/auth/sign-in/email',
        data: {'email': email, 'password': password},
      );
      final body = res.data!;
      final user = body['user'] as Map<String, dynamic>;
      final role = UserRole.fromId((user['roleId'] as num?)?.toInt());
      if (role == null) return const Err(ForbiddenFailure());
      return Success(
        AuthSession(
          user: AuthUser(
            id: user['id'] as String,
            email: user['email'] as String,
            name: user['name'] as String?,
            role: role,
            emailVerified: user['emailVerified'] as bool? ?? false,
          ),
          accessToken: body['token'] as String,
        ),
      );
    } on DioException catch (e) {
      return Err(_mapError(e));
    } catch (_) {
      return const Err(ServerFailure());
    }
  }

  @override
  Future<Result<void>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) =>
      _post('/api/auth/sign-up/email', {
        'name': name,
        'email': email,
        'password': password,
      });

  @override
  Future<Result<void>> resendVerificationEmail({required String email}) =>
      _post('/api/auth/send-verification-email', {'email': email});

  @override
  Future<Result<AuthSession>> signInWithGoogle() async =>
      const Err(ServerFailure('Google sign-in is not available yet.'));

  @override
  Future<Result<void>> sendPasswordReset({required String email}) =>
      _post('/api/auth/request-password-reset', {'email': email});

  @override
  Future<Result<void>> signOut() async {
    try {
      await _dio.post<void>('/api/auth/sign-out');
    } on DioException catch (_) {}
    await _tokenStorage.clear();
    return const Success(null);
  }

  Future<Result<void>> _post(String path, Map<String, dynamic> data) async {
    try {
      await _dio.post<void>(path, data: data);
      return const Success(null);
    } on DioException catch (e) {
      return Err(_mapError(e));
    } catch (_) {
      return const Err(ServerFailure());
    }
  }

  Failure _mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    final code = data is Map ? data['code'] as String? : null;
    final message = data is Map ? data['message'] as String? : null;

    if (status == null) return const NetworkFailure();
    if (status == 401) return const UnauthorizedFailure();
    if (status == 403) {
      return code == 'EMAIL_NOT_VERIFIED'
          ? const EmailNotVerifiedFailure()
          : const ForbiddenFailure();
    }
    if (status == 400 || status == 422) {
      return ValidationFailure(message ?? 'Invalid request.');
    }
    return const ServerFailure();
  }
}