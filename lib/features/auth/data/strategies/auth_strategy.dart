import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';

abstract class AuthStrategy<T extends AuthCredential> {
  bool canHandle(AuthCredential credential);
  Future<AuthUser?> signIn(T credential);

  /// Optional for signup flows.
  Future<void> signUp(T credential) async {}
}

