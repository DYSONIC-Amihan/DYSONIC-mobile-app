import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SsoButton extends StatelessWidget {
  final String label;
  final IconData icon; // swap for a Google logo asset later
  final bool loading;
  final VoidCallback? onPressed;

  const SsoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = LucideIcons.globe,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      width: double.infinity,
      enabled: !loading,
      onPressed: onPressed,
      leading: loading
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, size: 16),
      child: Text(label),
    );
  }
}
