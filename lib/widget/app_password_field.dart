import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.id = 'password',
    this.label = 'Password',
    this.placeholder = 'Enter your password',
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.enabled = true,
  });

  final String id;
  final String label;
  final String placeholder;
  final String? Function(String value)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool enabled;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      id: widget.id,
      label: widget.label,
      placeholder: widget.placeholder,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      obscureText: _obscure,
      trailing: ShadIconButton.ghost(
        width: 24,
        height: 24,
        padding: EdgeInsets.zero,
        icon: Icon(_obscure ? LucideIcons.eye : LucideIcons.eyeOff, size: 16),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
