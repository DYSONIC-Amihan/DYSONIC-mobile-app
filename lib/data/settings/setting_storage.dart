import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_settings.dart';
import '../../theme/app_pallete.dart';

class SettingsStorage {
  const SettingsStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'settings.theme_mode';
  static const _paletteKey = 'settings.palette';

  AppSettings read() {
    return AppSettings(
      themeMode:
          ThemeMode.values.asNameMap()[_prefs.getString(_themeModeKey)] ??
          ThemeMode.system,
      palette:
          AppPalette.values.asNameMap()[_prefs.getString(_paletteKey)] ??
          AppPalette.standard,
    );
  }

  Future<void> write(AppSettings settings) async {
    await _prefs.setString(_themeModeKey, settings.themeMode.name);
    await _prefs.setString(_paletteKey, settings.palette.name);
  }
}
