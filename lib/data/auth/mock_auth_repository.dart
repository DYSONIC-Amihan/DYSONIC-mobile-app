import '../../core/failure.dart';
import '../../core/util/result.dart';
import 'auth_repository.dart';
import 'auth_user.dart';

class MockAuthRepository implements AuthRepository {
  Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 800));

  AuthSession _session(String email, {String? name}) => AuthSession(
    user: AuthUser(
      id: 'mock-user',
      email: email,
      name: name,
      role: email.toLowerCase().startsWith('admin')
          ? UserRole.admin
          : UserRole.normal,
      emailVerified: true,
    ),
    accessToken: 'mock-access-token',
  );

  @override
  Future<Result<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _latency();
    if (password == 'wrongpass') return const Err(UnauthorizedFailure());
    return Success(_session(email));
  }

  @override
  Future<Result<void>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    await _latency();
    return const Success(null);
  }

  @override
  Future<Result<void>> resendVerificationEmail({required String email}) async {
    await _latency();
    return const Success(null);
  }

  @override
  Future<Result<AuthSession>> signInWithGoogle() async {
    await _latency();
    return Success(_session('google.user@example.com', name: 'Google User'));
  }

  @override
  Future<Result<void>> sendPasswordReset({required String email}) async {
    await _latency();
    return const Success(null);
  }

  @override
  Future<Result<void>> signOut() async {
    await _latency();
    return const Success(null);
  }
}
