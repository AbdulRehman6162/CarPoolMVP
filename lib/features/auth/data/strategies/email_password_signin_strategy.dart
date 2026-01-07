import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';
import 'auth_strategy.dart';

class EmailPasswordSignInStrategy
    implements AuthStrategy<EmailPasswordLoginCredential> {
  final AuthRemoteDataSource _remote;
  EmailPasswordSignInStrategy(this._remote);

  @override
  bool canHandle(AuthCredential credential) =>
      credential is EmailPasswordLoginCredential;

  @override
  Future<AuthUser?> signIn(EmailPasswordLoginCredential credential) async {
    final AuthUserModel model =
        await _remote.login(credential.email, credential.password);
    return model.toEntity();
  }
}

