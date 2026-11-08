import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Color palettes the user can choose from. Add a new value and a matching
/// case in [apply] to support another palette.
enum AppPalette {
  standard('Standard'),
  colorBlindSafe('Color-blind friendly');

  const AppPalette(this.label);

  final String label;

  ShadColorScheme apply(ShadColorScheme base, Brightness brightness) {
    return switch (this) {
      AppPalette.standard => base,
      AppPalette.colorBlindSafe => _colorBlindSafe(base, brightness),
    };
  }

  // Okabe-Ito palette: blue and vermillion stay distinct for protanopia,
  // deuteranopia and tritanopia.
  static ShadColorScheme _colorBlindSafe(
    ShadColorScheme base,
    Brightness brightness,
  ) {
    const blue = Color(0xFF0072B2);
    const skyBlue = Color(0xFF56B4E9);
    const vermillion = Color(0xFFD55E00);
    const white = Color(0xFFFFFFFF);
    const nearBlack = Color(0xFF0B0B0B);

    final isDark = brightness == Brightness.dark;
    final primary = isDark ? skyBlue : blue;

    return base.copyWith(
      primary: primary,
      primaryForeground: isDark ? nearBlack : white,
      destructive: vermillion,
      destructiveForeground: white,
      ring: primary,
    );
  }
}