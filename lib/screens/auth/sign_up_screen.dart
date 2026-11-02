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
import 'controllers/sign_up_controller.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_error_alert.dart';
import 'widgets/auth_layout.dart';
import 'widgets/or_divider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  String _password = '';
  String? _sentTo;
  bool _resent = false;

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.saveAndValidate()) return;
    final email = (form.value['email'] as String).trim();
    final ok = await ref.read(signUpControllerProvider.notifier).signUp(
          name: (form.value['name'] as String).trim(),
          email: email,
          password: form.value['password'] as String,
        );
    if (ok && mounted) setState(() => _sentTo = email);
  }

  Future<void> _resend() async {
    final ok = await ref
        .read(signUpControllerProvider.notifier)
        .resendVerification(_sentTo!);
    if (ok && mounted) setState(() => _resent = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final controller = ref.read(signUpControllerProvider.notifier);
    final theme = ShadTheme.of(context);
    final busy = state.isLoading;

    if (_sentTo != null) {
      return AuthLayout(
        child: AuthCard(
          title: 'Check your inbox',
          description: _resent
              ? 'Verification email sent again to $_sentTo.'
              : 'We sent a verification link to $_sentTo.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.failure != null) ...[
                AuthErrorAlert(failure: state.failure!),
                const SizedBox(height: 16),
              ],
              AppButton(
                label: 'Resend email',
                variant: AppButtonVariant.outline,
                isLoading: busy,
                onPressed: _resend,
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Back to log in',
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      );
    }

    return AuthLayout(
      child: AuthCard(
        title: 'Create an account',
        description: 'Sign up to start using DYSONIC',
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account?', style: theme.textTheme.muted),
            ShadButton.link(
              onPressed: busy ? null : () => context.go(AppRoutes.login),
              child: const Text('Log in'),
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
                id: 'name',
                label: 'Name',
                placeholder: 'Your name',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, 'Name'),
                enabled: !busy,
              ),
              const SizedBox(height: 16),
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
                placeholder: 'At least 8 characters',
                textInputAction: TextInputAction.next,
                validator: Validators.password,
                onChanged: (v) => _password = v,
                enabled: !busy,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                id: 'confirmPassword',
                label: 'Confirm password',
                placeholder: 'Re-enter your password',
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(() => _password),
                enabled: !busy,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Create account',
                isLoading: busy,
                onPressed: _submit,
              ),
              const OrDivider(),
              SsoButton(
                label: 'Sign up with Google',
                onPressed: busy ? null : controller.signInWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}