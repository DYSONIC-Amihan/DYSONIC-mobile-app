import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/failure.dart';
import '../../../data/auth/auth_user.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/session_provider.dart';
import '../../../core/util/result.dart';

class AuthFormState {
  const AuthFormState({
    this.isLoading = false,
    this.failure,
    this.isSuccess = false,
  });

  final bool isLoading;
  final Failure? failure;
  final bool isSuccess;
}

abstract class AuthFormController extends Notifier<AuthFormState> {
  @override
  AuthFormState build() => const AuthFormState();

  /// Runs [action], updates [state], and returns true on success.
  Future<bool> runAction<T>(
    Future<Result<T>> Function() action, {
    void Function(T data)? onSuccess,
  }) async {
    state = const AuthFormState(isLoading: true);
    final result = await action();
    if (!ref.mounted) return false;

    switch (result) {
      case Success<T>(:final data):
        onSuccess?.call(data);
        state = const AuthFormState(isSuccess: true);
        return true;
      case Err<T>(:final failure):
        state = AuthFormState(failure: failure);
        return false;
    }
  }
}

/// Shared by every screen that offers "Continue with Google".
mixin GoogleSsoMixin on AuthFormController {
  Future<bool> signInWithGoogle() => runAction<AuthSession>(
        () => ref.read(authRepositoryProvider).signInWithGoogle(),
        onSuccess: ref.read(sessionProvider.notifier).setSession,
      );
}