import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/auth/auth_user.dart';
import '../../../providers/account_providers.dart';
import '../../../providers/session_provider.dart';
import '../../auth/controllers/auth_form_controller.dart';

class UpdateNameController extends AuthFormController {
  Future<bool> submit(String name) => runAction<AuthUser>(
    () => ref.read(accountRepositoryProvider).updateName(name),
    onSuccess: ref.read(sessionProvider.notifier).updateUser,
  );
}

class AvatarController extends AuthFormController {
  Future<bool> select(String avatarId) => runAction<String>(
    () => ref.read(accountRepositoryProvider).updateAvatar(avatarId),
    onSuccess: (image) {
      final user = ref.read(sessionProvider)?.user;
      if (user == null) return;
      ref
          .read(sessionProvider.notifier)
          .updateUser(user.copyWith(image: image));
    },
  );
}

class ChangePasswordController extends AuthFormController {
  Future<bool> submit({
    required String currentPassword,
    required String newPassword,
  }) => runAction<void>(
    () => ref
        .read(accountRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
  );
}

final updateNameControllerProvider =
    NotifierProvider.autoDispose<UpdateNameController, AuthFormState>(
      UpdateNameController.new,
    );

final avatarControllerProvider =
    NotifierProvider.autoDispose<AvatarController, AuthFormState>(
      AvatarController.new,
    );

final changePasswordControllerProvider =
    NotifierProvider.autoDispose<ChangePasswordController, AuthFormState>(
      ChangePasswordController.new,
    );
