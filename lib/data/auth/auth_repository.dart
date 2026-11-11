import '../../core/util/result.dart';
import 'auth_user.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  });

  /// The backend requires email verification, so no session is returned.
  /// Success means "verification email sent".
  Future<Result<void>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> resendVerificationEmail({required String email});

  Future<Result<AuthSession>> signInWithGoogle();

  Future<Result<void>> sendPasswordReset({required String email});

  Future<Result<void>> signOut();
}
