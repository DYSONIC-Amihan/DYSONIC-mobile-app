import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../router/app_routes.dart';
import '../../core/util/validators.dart';
import '../../widget/app_button.dart';
import '../../widget/app_text_field.dart';
import 'controllers/forgot_password_controller.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_error_alert.dart';
import 'widgets/auth_layout.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.saveAndValidate()) return;
    await ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetLink((form.value['email'] as String).trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final busy = state.isLoading;

    return AuthLayout(
      child: AuthCard(
        title: 'Forgot password?',
        description: "Enter your email and we'll send you a reset link",
        footer: ShadButton.link(
          onPressed: busy ? null : () => context.go(AppRoutes.login),
          child: const Text('Back to log in'),
        ),
        child: ShadForm(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.failure != null) ...[
                AuthErrorAlert(failure: state.failure!),
                const SizedBox(height: 16),
              ],
              if (state.isSuccess) ...[
                const ShadAlert(
                  icon: Icon(LucideIcons.mail),
                  title: Text('Check your email'),
                  description: Text(
                    'If an account exists for that email, a reset link is on its way.',
                  ),
                ),
                const SizedBox(height: 16),
              ],
              AppTextField(
                id: 'email',
                label: 'Email',
                placeholder: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validators.email,
                enabled: !busy,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Send reset link',
                isLoading: busy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
