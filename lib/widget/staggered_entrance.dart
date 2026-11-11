import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/app_motion.dart';

class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.maxStaggeredItems = 6,
    this.offset = const Offset(-16, 0),
  });

  final int index;
  final Widget child;
  final int maxStaggeredItems;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final delay = AppMotion.stagger * math.min(index, maxStaggeredItems);
    final total = AppMotion.medium + delay;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: total,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: AppMotion.emphasized,
      ),
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: offset * (1 - value), child: child),
      ),
    );
  }
}
