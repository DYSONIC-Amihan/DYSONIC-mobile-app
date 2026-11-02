import '../../core/failure.dart';
import '../../core/util/result.dart';
import 'auth_repository.dart';
import 'auth_user.dart';
import '.././auth/mobile_access_policy.dart';

class GuardedAuthRepository implements AuthRepository {
  const GuardedAuthRepository(this._inner);

  final AuthRepository _inner;

  Future<Result<AuthSession>> _enforce(Result<AuthSession> result) async {
    switch (result) {
      case Success<AuthSession>(:final data):
        if (MobileAccessPolicy.isAllowed(data.user)) return result;
        await _inner.signOut();
        return const Err(
          ForbiddenFailure(
            'Admin accounts cannot sign in on the mobile app. '
            'Please use the web dashboard.',
          ),
        );
      case Err<AuthSession>():
        return result;
    }
  }

  @override
  Future<Result<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async =>
      _enforce(await _inner.signInWithEmail(email: email, password: password));

  @override
  Future<Result<AuthSession>> signInWithGoogle() async =>
      _enforce(await _inner.signInWithGoogle());

  @override
  Future<Result<void>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) => _inner.signUpWithEmail(name: name, email: email, password: password);

  @override
  Future<Result<void>> resendVerificationEmail({required String email}) =>
      _inner.resendVerificationEmail(email: email);

  @override
  Future<Result<void>> sendPasswordReset({required String email}) =>
      _inner.sendPasswordReset(email: email);

  @override
  Future<Result<void>> signOut() => _inner.signOut();
}
