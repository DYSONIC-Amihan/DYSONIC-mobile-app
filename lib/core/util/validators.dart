abstract final class Validators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? email(String? value) {
    final empty = required(value, 'Email');
    if (empty != null) return empty;
    if (!_emailRegex.hasMatch(value!.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final empty = required(value, 'Password');
    if (empty != null) return empty;
    if (value!.length < 8) return 'Use at least 8 characters';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value != original()) return 'Passwords do not match';
      return null;
    };
  }
}