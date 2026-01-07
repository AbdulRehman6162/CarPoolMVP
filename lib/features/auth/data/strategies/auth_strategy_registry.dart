import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_strategy.dart';

class AuthStrategyRegistry {
  final List<AuthStrategy> _strategies;

  AuthStrategyRegistry(this._strategies);

  AuthStrategy<T> _get<T extends AuthCredential>(T credential) {
    for (final s in _strategies) {
      if (s.canHandle(credential)) {
        return s as AuthStrategy<T>;
      }
    }
    throw StateError('No auth strategy registered for ${credential.runtimeType}');
  }

  Future<AuthUser?> signIn(AuthCredential credential) async {
    final s = _get(credential);
    return s.signIn(credential as dynamic);
  }

  Future<void> signUp(AuthCredential credential) async {
    final s = _get(credential);
    return s.signUp(credential as dynamic);
  }
}

