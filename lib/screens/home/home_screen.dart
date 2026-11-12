import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/auth/auth_user.dart';
import '../../providers/session_provider.dart';
import '../../widget/app_drawer.dart';
import '../../widget/app_section.dart';
import '../../widget/staggered_entrance.dart';
import '../../widget/user_avatar.dart';
import 'home_sections.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    if (user == null) return const SizedBox.shrink();

    final theme = ShadTheme.of(context);
    final sections = homeSections
        .where((section) => section.isVisibleFor(user.role))
        .toList();

    Future<void> refresh() => Future.wait([
      for (final section in sections)
        if (section.onRefresh case final onRefresh?) onRefresh(ref),
    ]);

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
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              StaggeredEntrance(
                index: 0,
                offset: const Offset(0, 16),
                child: _HomeHeader(user: user),
              ),
              const SizedBox(height: 32),
              for (final (index, section) in sections.indexed)
                StaggeredEntrance(
                  index: index + 1,
                  offset: const Offset(0, 16),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: AppSection(
                      title: section.title,
                      children: [section.builder(context)],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final firstName = (user.name ?? '').trim().split(' ').first;

    return Row(
      children: [
        UserAvatar(
          name: user.name ?? user.email,
          imageUrl: user.image,
          radius: 28,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstName.isEmpty ? 'Welcome' : 'Welcome, $firstName',
                style: theme.textTheme.h3,
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
    );
  }
}
