import 'dart:async';

import '../../../../core/env/env.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';
import 'auth_strategy.dart';

class OAuthSignInStrategy extends AuthStrategy {
  final AuthRemoteDataSource _remote;
  OAuthSignInStrategy(this._remote);

  @override
  bool canHandle(AuthCredential credential) => credential is OAuthSignInCredential;

  @override
  Future<AuthUser?> signIn(AuthCredential credential) async {
    final c = credential as OAuthSignInCredential;

    // Start the OAuth flow. For Supabase, this opens an external browser and returns quickly.
    final redirectTo =
        Env.authOAuthRedirectUrl.isNotEmpty ? Env.authOAuthRedirectUrl : null;

    await _remote.startOAuthSignIn(provider: c.provider, redirectTo: redirectTo);

    // Wait for auth state change to deliver the session user.
    // This keeps the repository API consistent (signIn returns a user).
    final completer = Completer<AuthUserModel>();

    late final StreamSubscription sub;
    sub = _remote.authStateChanges.listen((model) {
      if (model != null && !completer.isCompleted) {
        completer.complete(model);
      }
    });

    try {
      final model =
          await completer.future.timeout(const Duration(seconds: 90));
      return model.toEntity();
    } finally {
      await sub.cancel();
    }
  }
}
