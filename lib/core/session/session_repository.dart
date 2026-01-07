import 'session_user.dart';

abstract class SessionRepository {
  Stream<SessionUser?> get authStateChanges;
  Future<SessionUser?> getCurrentUser();
  Future<void> signOut();
}

