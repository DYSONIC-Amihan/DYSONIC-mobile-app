import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_providers.dart';
import 'auth_form_controller.dart';

class SignUpController extends AuthFormController with GoogleSsoMixin {
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      runAction<void>(
        () => ref.read(authRepositoryProvider).signUpWithEmail(
              name: name,
              email: email,
              password: password,
            ),
      );

  Future<bool> resendVerification(String email) => runAction<void>(
        () => ref
            .read(authRepositoryProvider)
            .resendVerificationEmail(email: email),
      );
}

final signUpControllerProvider =
    NotifierProvider.autoDispose<SignUpController, AuthFormState>(
  SignUpController.new,
);