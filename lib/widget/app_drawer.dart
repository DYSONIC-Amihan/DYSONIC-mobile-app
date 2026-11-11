import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../providers/session_provider.dart';
import '../router/nav_destinations.dart';
import '../widget/user_avatar.dart';
import 'confirm_dialog.dart';
import 'staggered_entrance.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Sign out?',
      description: 'You will need to sign in again to access your account.',
      confirmLabel: 'Sign out',
      destructive: true,
    );

    if (!confirmed || !context.mounted) return;

    Navigator.of(context).pop(); // close drawer
    await ref.read(sessionProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    if (user == null) return const SizedBox.shrink();

    final theme = ShadTheme.of(context);
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final visibleDestinations = navDestinations
        .where((d) => d.isVisibleFor(user.role))
        .toList();

    return Drawer(
      backgroundColor: theme.colorScheme.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DYSONIC', style: theme.textTheme.h4),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      UserAvatar(
                        name: user.name ?? user.email,
                        imageUrl: user.image,
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (user.name != null && user.name!.isNotEmpty)
                              Text(
                                user.name!,
                                style: theme.textTheme.large,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Text(
                              user.email,
                              style: theme.textTheme.muted,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                children: [
                  for (final (index, item) in visibleDestinations.indexed)
                    StaggeredEntrance(
                      index: index,
                      child: ListTile(
                        leading: Icon(item.icon, size: 20),
                        title: Text(item.label),
                        selected: currentRoute == item.route,
                        selectedTileColor: theme.colorScheme.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(); // close drawer
                          if (currentRoute != item.route) {
                            context.go(item.route);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: StaggeredEntrance(
                index: visibleDestinations.length,
                child: ListTile(
                  leading: const Icon(LucideIcons.logOut, size: 20),
                  title: const Text('Sign out'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () => _handleSignOut(context, ref),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}