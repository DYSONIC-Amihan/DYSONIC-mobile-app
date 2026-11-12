import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../core/failure.dart';
import '../theme/app_motion.dart';

/// Shows a loading card, an error alert with retry, or the data.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.medium,
      child: value.when(
        loading: () => const _LoadingCard(key: ValueKey('loading')),
        error: (error, _) => _ErrorCard(
          key: const ValueKey('error'),
          message: error is Failure ? error.message : 'Something went wrong.',
          onRetry: onRetry,
        ),
        data: (result) =>
            KeyedSubtree(key: const ValueKey('data'), child: data(result)),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShadAlert.destructive(
          icon: const Icon(LucideIcons.circleAlert),
          title: Text(message),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          ShadButton.outline(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ],
    );
  }
}
