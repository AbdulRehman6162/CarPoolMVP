/// Domain-safe authentication event types.
///
/// This abstracts provider-specific auth events (e.g., Supabase) so higher layers do not depend
/// on external SDK enums (DIP) and routing guards remain stable (OCP).
enum AuthEventType {
  initialSession,
  signedIn,
  signedOut,
  tokenRefreshed,
  userUpdated,
  passwordRecovery,
  unknown,
}
