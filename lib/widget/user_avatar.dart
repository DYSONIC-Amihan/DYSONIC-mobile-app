import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.name, this.imageUrl, this.radius = 20});

  final String? name;
  final String? imageUrl;
  final double radius;

  String get _initials {
    final parts = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final url = imageUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.muted,
      foregroundColor: theme.colorScheme.mutedForeground,
      foregroundImage: url == null || url.isEmpty ? null : NetworkImage(url),
      child: Text(_initials),
    );
  }
}
