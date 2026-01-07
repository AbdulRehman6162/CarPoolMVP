class Env {
  // These are compile-time values injected via --dart-define or --dart-define-from-file.
  static const String supabaseUrl =
  String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static const String supabaseAnonKey =
  String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

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
