import '../../../../core/session/session_repository.dart';
import '../../../../core/session/session_user.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthSessionRepository implements SessionRepository {
  final AuthRepository _authRepository;

  AuthSessionRepository(this._authRepository);

  @override
  Stream<SessionUser?> get authStateChanges =>
      _authRepository.authStateChanges.map(_map);

  @override
  Future<SessionUser?> getCurrentUser() async {
    final u = await _authRepository.getCurrentUser();
    return _map(u);
  }

  @override
  Future<void> signOut() => _authRepository.signOut();

  SessionUser? _map(AuthUser? user) {
    if (user == null) return null;
    return SessionUser(
      id: user.id,
      email: user.email,
      phone: user.phoneNumber,
      displayName: user.name,
    );
  }
}

