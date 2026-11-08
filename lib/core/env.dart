abstract final class Env {
  /// Run with: --dart-define=API_BASE_URL=https://api.yourapp.com
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  /// Must be the *Web* OAuth client ID — the same value as GOOGLE_CLIENT_ID
  /// on the backend, so the ID token's audience matches what better-auth checks.
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  /// Run with: --dart-define=USE_MOCK=false to hit the real backend.
  static const useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
}