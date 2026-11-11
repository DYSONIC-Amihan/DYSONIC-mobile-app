import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/failure.dart';
import '../../../data/account/avatar_option.dart';
import '../../../providers/account_providers.dart';
import '../../../providers/session_provider.dart';
import '../../../widget/app_button.dart';
import '../../../widget/user_avatar.dart';
import '../../auth/widgets/auth_error_alert.dart';
import '../controllers/account_controllers.dart';

Future<void> showAvatarPicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const AvatarPickerSheet(),
  );
}

class AvatarPickerSheet extends ConsumerWidget {
  const AvatarPickerSheet({super.key});

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    AvatarOption avatar,
  ) async {
    final ok = await ref
        .read(avatarControllerProvider.notifier)
        .select(avatar.id);
    if (ok && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final avatars = ref.watch(avatarsProvider);
    final state = ref.watch(avatarControllerProvider);
    final currentImage = ref.watch(sessionProvider)?.user.image;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose an avatar', style: theme.textTheme.h4),
            const SizedBox(height: 16),
            if (state.failure != null) ...[
              AuthErrorAlert(failure: state.failure!),
              const SizedBox(height: 16),
            ],
            avatars.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    error is Failure
                        ? error.message
                        : 'Could not load avatars.',
                    style: theme.textTheme.muted,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Retry',
                    variant: AppButtonVariant.outline,
                    onPressed: () => ref.invalidate(avatarsProvider),
                  ),
                ],
              ),
              data: (items) => Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final (index, avatar) in items.indexed)
                    _AvatarChoice(
                      label: 'Avatar ${index + 1}',
                      url: avatar.url,
                      selected: avatar.url == currentImage,
                      onTap: state.isLoading
                          ? null
                          : () => _select(context, ref, avatar),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.label,
    required this.url,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String url;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ShadTheme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkResponse(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? colors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
              child: UserAvatar(imageUrl: url, radius: 36),
            ),
            if (selected)
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: colors.primary,
                  child: Icon(
                    LucideIcons.check,
                    size: 14,
                    color: colors.primaryForeground,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
