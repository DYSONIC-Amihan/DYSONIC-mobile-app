import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/env.dart';
import '../data/account/account_repository.dart';
import '../data/account/api_account_repository.dart';
import '../data/account/avatar_option.dart';
import '../data/account/mock_account_repository.dart';
import 'auth_providers.dart';
import 'session_provider.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  if (Env.useMock) {
    return MockAccountRepository(() => ref.read(sessionProvider)?.user);
  }
  return ApiAccountRepository(
    ref.watch(dioProvider),
    ref.watch(tokenStorageProvider),
  );
});

final avatarsProvider = FutureProvider.autoDispose<List<AvatarOption>>(
  (ref) async {
    final result = await ref.watch(accountRepositoryProvider).fetchAvatars();
    return result.when(
      onSuccess: (avatars) => avatars,
      onFailure: (failure) => throw failure,
    );
  },
  // Riverpod 3 retries failed providers by default; show the error instead.
  retry: (_, _) => null,
);
