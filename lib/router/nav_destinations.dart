import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../data/auth/auth_user.dart';
import 'app_routes.dart';

/// One entry in the app's navigation menu.
class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.route,
    this.roles, // null = visible to everyone
  });

  final String label;
  final IconData icon;
  final String route;
  final Set<UserRole>? roles;

  bool isVisibleFor(UserRole role) => roles == null || roles!.contains(role);
}

/// Add a new screen to the menu by adding one entry here
/// (and a matching GoRoute in app_router.dart).
const navDestinations = <NavDestination>[
  NavDestination(
    label: 'Home',
    icon: LucideIcons.house,
    route: AppRoutes.home,
  ),
  NavDestination(
    label: 'Account',
    icon: LucideIcons.user,
    route: AppRoutes.account,
  ),
  NavDestination(
    label: 'Settings',
    icon: LucideIcons.settings,
    route: AppRoutes.settings,
  ),
];