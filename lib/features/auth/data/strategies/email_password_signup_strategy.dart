import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../datasources/auth_remote_data_source.dart';
import 'auth_strategy.dart';

class EmailPasswordSignUpStrategy extends AuthStrategy {
  final AuthRemoteDataSource _remote;
  EmailPasswordSignUpStrategy(this._remote);

  @override
  bool canHandle(AuthCredential credential) =>
      credential is EmailPasswordSignupCredential;

  @override
  Future<AuthUser?> signIn(AuthCredential credential) async {
    // Signup is not a sign-in step; it may require verification.
    return null;
  }

  @override
  Future<void> signUp(AuthCredential credential) async {
    final c = credential as EmailPasswordSignupCredential;
    await _remote.signup(name: c.name, email: c.email, password: c.password);
  }
}
