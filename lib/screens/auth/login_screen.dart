import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../router/app_routes.dart';
import '../../core/util/validators.dart';
import '../../widget/app_button.dart';
import '../../widget/app_password_field.dart';
import '../../widget/app_text_field.dart';
import '../../widget/sso_button.dart';
import 'controllers/login_controller.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_error_alert.dart';
import 'widgets/auth_layout.dart';
import 'widgets/or_divider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.saveAndValidate()) return;
    await ref
        .read(loginControllerProvider.notifier)
        .signInWithEmail(
          email: (form.value['email'] as String).trim(),
          password: form.value['password'] as String,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    final theme = ShadTheme.of(context);
    final busy = state.isLoading;

    return AuthLayout(
      child: AuthCard(
        title: 'Welcome back',
        description: 'Log in to your DYSONIC account',
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No account yet?', style: theme.textTheme.muted),
            ShadButton.link(
              onPressed: busy ? null : () => context.go(AppRoutes.signUp),
              child: const Text('Sign up'),
            ),
          ],
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
              AppTextField(
                id: 'email',
                label: 'Email',
                placeholder: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                enabled: !busy,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                textInputAction: TextInputAction.done,
                validator: (v) => Validators.required(v, 'Password'),
                enabled: !busy,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ShadButton.link(
                  onPressed: busy
                      ? null
                      : () => context.go(AppRoutes.forgotPassword),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 8),
              AppButton(label: 'Log in', isLoading: busy, onPressed: _submit),
              const OrDivider(),
              SsoButton(
                label: 'Continue with Google',
                onPressed: busy ? null : controller.signInWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
