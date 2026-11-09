import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/auth/auth_user.dart';
import '../../providers/session_provider.dart';
import '../../widget/app_button.dart';
import '../../widget/app_drawer.dart';
import '../../widget/app_selection.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    // The router redirects to login when signed out; this just avoids a flash.
    if (user == null) return const SizedBox.shrink();

    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: theme.colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _ProfileHeader(user: user),
            const SizedBox(height: 32),
            AppSection(
              title: 'Details',
              children: [
                _AccountInfoTile(
                  icon: LucideIcons.user,
                  label: 'Name',
                  value: (user.name?.trim().isNotEmpty ?? false)
                      ? user.name!.trim()
                      : 'Not set',
                ),
                _AccountInfoTile(
                  icon: LucideIcons.mail,
                  label: 'Email',
                  value: user.email,
                  trailing: _VerificationBadge(isVerified: user.emailVerified),
                ),
                _AccountInfoTile(
                  icon: LucideIcons.shield,
                  label: 'Role',
                  value: user.role.label,
                ),
              ],
            ),
            // Future sections (change password, linked accounts, delete
            // account, ...) go here as more AppSection entries.
            const SizedBox(height: 32),
            AppButton(
              label: 'Sign out',
              variant: AppButtonVariant.outline,
              icon: const Icon(LucideIcons.logOut, size: 16),
              onPressed: () => ref.read(sessionProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.primaryForeground,
          child: Text(user.initials, style: theme.textTheme.h3),
        ),
        const SizedBox(height: 16),
        Text(
          user.displayName,
          style: theme.textTheme.h4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(user.email, style: theme.textTheme.muted),
      ],
    );
  }
}

class _AccountInfoTile extends StatelessWidget {
  const _AccountInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: theme.colorScheme.mutedForeground),
      title: Text(label, style: theme.textTheme.muted),
      subtitle: Text(value, style: theme.textTheme.p),
      trailing: trailing,
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  const _VerificationBadge({required this.isVerified});

  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? const ShadBadge(child: Text('Verified'))
        : const ShadBadge.destructive(child: Text('Unverified'));
  }
}