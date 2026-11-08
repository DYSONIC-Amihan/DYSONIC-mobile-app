import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_settings.dart';
import '../data/settings/setting_storage.dart';
import '../theme/app_pallete.dart';

/// Overridden in main() with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider.'),
);

final settingsStorageProvider = Provider<SettingsStorage>(
  (ref) => SettingsStorage(ref.watch(sharedPreferencesProvider)),
);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(settingsStorageProvider).read();

  Future<void> setThemeMode(ThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  Future<void> setPalette(AppPalette palette) =>
      _update(state.copyWith(palette: palette));

  Future<void> _update(AppSettings next) async {
    state = next;
    await ref.read(settingsStorageProvider).write(next);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);