import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/auth/auth_user.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/session_provider.dart';
import 'auth_form_controller.dart';

class LoginController extends AuthFormController with GoogleSsoMixin {
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) => runAction<AuthSession>(
    () => ref
        .read(authRepositoryProvider)
        .signInWithEmail(email: email, password: password),
    onSuccess: ref.read(sessionProvider.notifier).setSession,
  );
}

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, AuthFormState>(
      LoginController.new,
    );
