import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Must be used inside a [ShadForm]; [id] is the key in the form's values.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.id,
    required this.label,
    this.placeholder,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.leading,
    this.trailing,
    this.enabled = true,
  });

  final String id;
  final String label;
  final String? placeholder;
  final String? Function(String value)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ShadInputFormField(
      id: id,
      label: Text(label),
      placeholder: placeholder == null ? null : Text(placeholder!),
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
    );
  }
}