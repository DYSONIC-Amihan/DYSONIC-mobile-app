import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../core/env.dart';
import '../core/token_storage.dart';
import '../data/auth/api_auth_repository.dart';
import '../data/auth/auth_repository.dart';
import '../data/auth/guarded_auth_repository.dart';
import '../data/auth/mock_auth_repository.dart';
import '../services/auth_services.dart';

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const TokenStorage(),
);

final dioProvider = Provider<Dio>(
  (ref) => createApiClient(ref.watch(tokenStorageProvider)),
);

final googleAuthServiceProvider = Provider<GoogleAuthService>(
  (ref) => GoogleAuthService(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final AuthRepository inner = Env.useMock
      ? MockAuthRepository()
      : ApiAuthRepository(
          ref.watch(dioProvider),
          ref.watch(tokenStorageProvider),
          ref.watch(googleAuthServiceProvider),
        );
  return GuardedAuthRepository(inner);
});
