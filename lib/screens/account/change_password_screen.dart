import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/util/validators.dart';
import '../../widget/app_button.dart';
import '../../widget/app_password_field.dart';
import '../auth/widgets/auth_error_alert.dart';
import 'controllers/account_controllers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  String _newPassword = '';

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.saveAndValidate()) return;

    final ok = await ref
        .read(changePasswordControllerProvider.notifier)
        .submit(
          currentPassword: form.value['currentPassword'] as String,
          newPassword: form.value['newPassword'] as String,
        );
    if (!ok || !mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password updated.')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordControllerProvider);
    final theme = ShadTheme.of(context);
    final busy = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        backgroundColor: theme.colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ShadForm(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'You will stay signed in on this device. '
                      'Other devices will be signed out.',
                      style: theme.textTheme.muted,
                    ),
                    const SizedBox(height: 24),
                    if (state.failure != null) ...[
                      AuthErrorAlert(failure: state.failure!),
                      const SizedBox(height: 16),
                    ],
                    AppPasswordField(
                      id: 'currentPassword',
                      label: 'Current password',
                      placeholder: 'Enter your current password',
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          Validators.required(v, 'Current password'),
                      enabled: !busy,
                    ),
                    const SizedBox(height: 16),
                    AppPasswordField(
                      id: 'newPassword',
                      label: 'New password',
                      placeholder: 'At least 8 characters',
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                      onChanged: (v) => _newPassword = v,
                      enabled: !busy,
                    ),
                    const SizedBox(height: 16),
                    AppPasswordField(
                      id: 'confirmPassword',
                      label: 'Confirm new password',
                      placeholder: 'Re-enter your new password',
                      textInputAction: TextInputAction.done,
                      validator: Validators.confirmPassword(() => _newPassword),
                      enabled: !busy,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Update password',
                      isLoading: busy,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
