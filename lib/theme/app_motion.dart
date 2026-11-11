import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration stagger = Duration(milliseconds: 40);

  static const Curve emphasized = Curves.easeOutCubic;
}
