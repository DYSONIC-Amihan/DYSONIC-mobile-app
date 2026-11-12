import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String description,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final result = await showShadDialog<bool>(
    context: context,
    builder: (dialogContext) => ShadDialog.alert(
      title: Text(title),
      description: Text(description),
      actions: [
        ShadButton.outline(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel),
        ),
        destructive
            ? ShadButton.destructive(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(confirmLabel),
              )
            : ShadButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(confirmLabel),
              ),
      ],
    ),
  );

  return result ?? false;
}
