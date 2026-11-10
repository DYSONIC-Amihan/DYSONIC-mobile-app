import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_pallete.dart';

abstract final class AppTheme {
  static ShadThemeData light(AppPalette palette) =>
      _build(Brightness.light, palette);

  static ShadThemeData dark(AppPalette palette) =>
      _build(Brightness.dark, palette);

  static ShadThemeData _build(Brightness brightness, AppPalette palette) {
    final ShadColorScheme base = brightness == Brightness.dark
        ? const ShadSlateColorScheme.dark()
        : const ShadSlateColorScheme.light();

    return ShadThemeData(
      brightness: brightness,
      colorScheme: palette.apply(base, brightness),
    );
  }
}
