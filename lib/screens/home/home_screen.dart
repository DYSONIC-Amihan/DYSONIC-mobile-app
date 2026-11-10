import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/session_provider.dart';
import '../../widget/app_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    final theme = ShadTheme.of(context);
    final firstName = (user?.name ?? '').split(' ').first;

    return Scaffold(
      appBar: AppBar(
        // The hamburger icon appears automatically because a drawer is set.
        title: const Text('Home'),
        backgroundColor: theme.colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              firstName.isEmpty ? 'Welcome' : 'Welcome, $firstName',
              style: theme.textTheme.h3,
            ),
            const SizedBox(height: 4),
            Text(user?.email ?? '', style: theme.textTheme.muted),
            const SizedBox(height: 24),
            // Dashboard sections go here later (device status, readings, etc.)
            const ShadCard(
              title: Text('Nothing here yet'),
              description: Text('Your devices and readings will show up here.'),
            ),
          ],
        ),
      ),
    );
  }
}
