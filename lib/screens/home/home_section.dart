import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth/auth_user.dart';

/// One block on the Home dashboard.
class HomeSection {
  const HomeSection({
    required this.title,
    required this.builder,
    this.onRefresh,
    this.roles,
  });

  final String title;

  /// Builds the section's content. Use a ConsumerWidget inside if it needs
  /// providers.
  final WidgetBuilder builder;

  /// Called on pull-to-refresh. Return the provider's refreshed future so
  /// the spinner stays until the data has reloaded.
  final Future<void> Function(WidgetRef ref)? onRefresh;

  /// null = visible to everyone.
  final Set<UserRole>? roles;

  bool isVisibleFor(UserRole role) => roles == null || roles!.contains(role);
}
