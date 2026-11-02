import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: DysonicApp()));
}

class DysonicApp extends ConsumerWidget {
  const DysonicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),
      appBuilder: (context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'DYSONIC',
        theme: Theme.of(context),
        routerConfig: router,
        builder: (context, child) => ShadAppBuilder(child: child!),
      ),
    );
  }
}