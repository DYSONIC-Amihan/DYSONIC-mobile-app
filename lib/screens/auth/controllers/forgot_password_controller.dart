import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_providers.dart';
import 'auth_form_controller.dart';

class ForgotPasswordController extends AuthFormController {
  Future<bool> sendResetLink(String email) => runAction<void>(
    () => ref.read(authRepositoryProvider).sendPasswordReset(email: email),
  );
}

final forgotPasswordControllerProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, AuthFormState>(
      ForgotPasswordController.new,
    );
