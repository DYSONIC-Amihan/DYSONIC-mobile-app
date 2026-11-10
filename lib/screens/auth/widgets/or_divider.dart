import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'or'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final line = Expanded(
      child: Container(height: 1, color: theme.colorScheme.border),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          line,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: theme.textTheme.muted),
          ),
          line,
        ],
      ),
    );
  }
}
