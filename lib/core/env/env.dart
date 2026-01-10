class Env {
  // These are compile-time values injected via --dart-define or --dart-define-from-file.
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  /// Redirect URL used for OAuth providers (Google / Apple / etc).
  /// Example: yourapp://auth/callback
  static const String authOAuthRedirectUrl =
      String.fromEnvironment('AUTH_OAUTH_REDIRECT_URL', defaultValue: '');

  /// Redirect URL used for password recovery.
  /// Example: yourapp://auth/recovery
  static const String authPasswordRecoveryRedirectUrl =
      String.fromEnvironment('AUTH_PASSWORD_RECOVERY_REDIRECT_URL', defaultValue: '');

  static void validate() {
    assert(
      supabaseUrl.isNotEmpty,
      'Missing SUPABASE_URL. Provide it using --dart-define or --dart-define-from-file.',
    );
    assert(
      supabaseAnonKey.isNotEmpty,
      'Missing SUPABASE_ANON_KEY. Provide it using --dart-define or --dart-define-from-file.',
    );
  }
}
