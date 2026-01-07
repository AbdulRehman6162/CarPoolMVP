import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_strategy.dart';

class OAuthSignInStrategy implements AuthStrategy<OAuthSignInCredential> {
  @override
  bool canHandle(AuthCredential credential) => credential is OAuthSignInCredential;

  @override
  Future<AuthUser?> signIn(OAuthSignInCredential credential) async {
    // Wire Supabase signInWithOAuth later.
    throw const NotImplementedFailure(debugMessage: 'OAuth sign-in not wired yet');
  }
}

