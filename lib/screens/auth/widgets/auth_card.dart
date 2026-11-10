import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.footer,
  });

  final String title;
  final String description;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: Text(title),
      description: Text(description),
      footer: footer,
      child: Padding(padding: const EdgeInsets.only(top: 16), child: child),
    );
  }
}
