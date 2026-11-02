import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/session_provider.dart';
import '../../widget/app_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider)?.user;
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Home', style: theme.textTheme.h3),
              const SizedBox(height: 8),
              Text(user?.email ?? '', style: theme.textTheme.muted),
              const Spacer(),
              AppButton(
                label: 'Sign out',
                variant: AppButtonVariant.outline,
                onPressed: () => ref.read(sessionProvider.notifier).signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}