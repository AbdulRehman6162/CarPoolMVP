import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../datasources/auth_remote_data_source.dart';
import 'auth_strategy.dart';

class EmailPasswordSignUpStrategy
    implements AuthStrategy<EmailPasswordSignupCredential> {
  final AuthRemoteDataSource _remote;
  EmailPasswordSignUpStrategy(this._remote);

  @override
  bool canHandle(AuthCredential credential) =>
      credential is EmailPasswordSignupCredential;

  @override
  Future<AuthUser?> signIn(EmailPasswordSignupCredential credential) async {
    // Not a sign-in; signup returns void and requires OTP.
    return null;
  }

  @override
  Future<void> signUp(EmailPasswordSignupCredential credential) async {
    await _remote.signup(
      name: credential.name,
      email: credential.email,
      password: credential.password,
    );
  }
}

