import 'package:google_sign_in/google_sign_in.dart';

import '../core/env.dart';
import '../core/failure.dart';

/// Wraps google_sign_in (v7 API) and returns a Google ID token for the backend.
class GoogleAuthService {
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: Env.googleServerClientId,
    );
    _initialized = true;
  }

  /// Returns the ID token, or throws a [Failure] (cancelled / failed).
  Future<String> getIdToken() async {
    try {
      await _init();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const ServerFailure('Google did not return an ID token.');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const UnknownFailure('Google sign-in was cancelled.');
      }
      throw const ServerFailure('Google sign-in failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _init();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}