import 'package:flutter/material.dart';

import '../theme/app_pallete.dart';

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.palette = AppPalette.standard,
  });

  final ThemeMode themeMode;
  final AppPalette palette;

  AppSettings copyWith({ThemeMode? themeMode, AppPalette? palette}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      palette: palette ?? this.palette,
    );
  }
}