import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/token_storage.dart';
import '../data/auth/auth_repository.dart';
import '../data/auth/guarded_auth_repository.dart';
import '../data/auth/mock_auth_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const TokenStorage(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final AuthRepository inner = MockAuthRepository();
  return GuardedAuthRepository(inner);
});
