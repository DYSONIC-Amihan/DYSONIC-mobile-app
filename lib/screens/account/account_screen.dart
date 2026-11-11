import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/auth/auth_user.dart';
import '../../providers/session_provider.dart';
import '../../router/app_routes.dart';
import '../../widget/app_drawer.dart';
import '../../widget/app_section.dart';
import '../../widget/user_avatar.dart';
import 'widgets/avatar_picker_sheet.dart';
import 'widgets/edit_name_dialog.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    final theme = ShadTheme.of(context);

    // The router redirects to login when signed out; this only covers the
    // frame between sign-out and the redirect.
    if (user == null) return const SizedBox.shrink();

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
            _AccountHeader(
              user: user,
              onChangeAvatar: () => showAvatarPicker(context),
            ),
            const SizedBox(height: 32),
            AppSection(
              title: 'Profile',
              children: [
                _InfoTile(
                  icon: LucideIcons.user,
                  label: 'Name',
                  value: (user.name?.isNotEmpty ?? false)
                      ? user.name!
                      : 'Not set',
                  onTap: () =>
                      showEditNameDialog(context, initialName: user.name ?? ''),
                ),
                _InfoTile(
                  icon: LucideIcons.mail,
                  label: 'Email',
                  value: user.email,
                ),
                if (user.createdAt != null)
                  _InfoTile(
                    icon: LucideIcons.calendar,
                    label: 'Member since',
                    value: MaterialLocalizations.of(
                      context,
                    ).formatMediumDate(user.createdAt!.toLocal()),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            AppSection(
              title: 'Security',
              children: [
                _InfoTile(
                  icon: LucideIcons.lock,
                  label: 'Password',
                  value: 'Change your password',
                  onTap: () => context.push(AppRoutes.changePassword),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.user, required this.onChangeAvatar});

  final AuthUser user;
  final VoidCallback onChangeAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      children: [
        Semantics(
          button: true,
          label: 'Change avatar',
          child: InkResponse(
            onTap: onChangeAvatar,
            customBorder: const CircleBorder(),
            child: Stack(
              children: [
                UserAvatar(
                  name: user.name ?? user.email,
                  imageUrl: user.image,
                  radius: 44,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      LucideIcons.pencil,
                      size: 14,
                      color: theme.colorScheme.primaryForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (user.name != null && user.name!.isNotEmpty)
          Text(user.name!, style: theme.textTheme.h3),
        Text(user.email, style: theme.textTheme.muted),
        const SizedBox(height: 12),
        if (user.emailVerified)
          const ShadBadge.secondary(child: Text('Email verified'))
        else
          const ShadBadge.destructive(child: Text('Email not verified')),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20),
      title: Text(label),
      subtitle: Text(value),
      trailing: onTap == null
          ? null
          : const Icon(LucideIcons.chevronRight, size: 16),
      onTap: onTap,
    );
  }
}
