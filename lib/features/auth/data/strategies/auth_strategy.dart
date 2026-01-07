import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';

/// OCP-friendly strategy interface for authentication.
/// Keep it NON-generic to avoid variance issues when registering multiple strategies.
abstract class AuthStrategy {
  bool canHandle(AuthCredential credential);

  /// Performs sign-in for the given credential.
  /// Implementations may throw (mapped to [Failure] in upper layers).
  Future<AuthUser?> signIn(AuthCredential credential);

  /// Optional for signup flows.
  Future<void> signUp(AuthCredential credential) async {}
}
