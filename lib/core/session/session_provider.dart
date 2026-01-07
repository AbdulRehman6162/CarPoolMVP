import 'dart:async';
import 'package:flutter/foundation.dart';

import 'session_repository.dart';
import 'session_user.dart';

class SessionProvider extends ChangeNotifier {
  final SessionRepository _repository;

  late final StreamSubscription<SessionUser?> _sub;

  SessionUser? _user;
  bool _isInitialized = false;

  SessionProvider(this._repository) {
    _sub = _repository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      _user = await _repository.getCurrentUser();
    } catch (_) {
      // ignore bootstrap issues
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  SessionUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  Future<void> logout() async {
    await _repository.signOut();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

