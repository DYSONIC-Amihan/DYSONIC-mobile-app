import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/util/validators.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../../auth/widgets/auth_error_alert.dart';
import '../controllers/account_controllers.dart';

Future<void> showEditNameDialog(
  BuildContext context, {
  required String initialName,
}) {
  return showShadDialog<void>(
    context: context,
    builder: (_) => EditNameDialog(initialName: initialName),
  );
}

class EditNameDialog extends ConsumerStatefulWidget {
  const EditNameDialog({super.key, required this.initialName});

  final String initialName;

  @override
  ConsumerState<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends ConsumerState<EditNameDialog> {
  final _formKey = GlobalKey<ShadFormState>();

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.saveAndValidate()) return;
    final ok = await ref
        .read(updateNameControllerProvider.notifier)
        .submit((form.value['name'] as String).trim());
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateNameControllerProvider);
    final busy = state.isLoading;

    return ShadDialog(
      title: const Text('Edit name'),
      description: const Text('This is how your name appears in the app.'),
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.ghost,
          expand: false,
          onPressed: busy ? null : () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: 'Save',
          expand: false,
          isLoading: busy,
          onPressed: _submit,
        ),
      ],
      child: ShadForm(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.failure != null) ...[
                AuthErrorAlert(failure: state.failure!),
                const SizedBox(height: 16),
              ],
              AppTextField(
                id: 'name',
                label: 'Name',
                placeholder: 'Your name',
                initialValue: widget.initialName,
                textInputAction: TextInputAction.done,
                validator: Validators.name,
                enabled: !busy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
