import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth/auth_user.dart';
import 'auth_providers.dart';

class SessionNotifier extends Notifier<AuthSession?> {
  @override
  AuthSession? build() => null;

  void setSession(AuthSession session) => state = session;

  void updateUser(AuthUser user) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(user: user);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = null;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, AuthSession?>(
  SessionNotifier.new,
);
