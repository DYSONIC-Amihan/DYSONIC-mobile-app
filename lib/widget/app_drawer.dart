import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../providers/session_provider.dart';
import '../router/nav_destinations.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    if (user == null) return const SizedBox.shrink();

    final theme = ShadTheme.of(context);
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final visibleDestinations =
        navDestinations.where((d) => d.isVisibleFor(user.role));

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
                  const SizedBox(height: 12),
                  if (user.name != null && user.name!.isNotEmpty)
                    Text(user.name!, style: theme.textTheme.large),
                  Text(user.email, style: theme.textTheme.muted),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                children: [
                  for (final item in visibleDestinations)
                    ListTile(
                      leading: Icon(item.icon, size: 20),
                      title: Text(item.label),
                      selected: currentRoute == item.route,
                      selectedTileColor: theme.colorScheme.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(); // close drawer
                        if (currentRoute != item.route) context.go(item.route);
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(LucideIcons.logOut, size: 20),
                title: const Text('Sign out'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(sessionProvider.notifier).signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}