import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/failure.dart';

class AuthErrorAlert extends StatelessWidget {
  const AuthErrorAlert({super.key, required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return ShadAlert.destructive(
      icon: const Icon(LucideIcons.circleAlert),
      title: Text(failure.message),
    );
  }
}
