import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/setting_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const DysonicApp(),
    ),
  );
}

class DysonicApp extends ConsumerWidget {
  const DysonicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    return ShadApp.custom(
      themeMode: settings.themeMode,
      theme: AppTheme.light(settings.palette),
      darkTheme: AppTheme.dark(settings.palette),
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
