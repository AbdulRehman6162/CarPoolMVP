import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  late final StreamSubscription<AuthUser?> _sub;

  AuthUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  AuthProvider(this._repository) {
    // Listen to repository changes (e.g., session expiry)
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
      // Ignore bootstrap errors; UI can retry login.
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  AuthUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.login(email, password);
      return true; // Success
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false; // Failed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.signup(name: name, email: email, password: password);
      return true; // Ready for OTP
    } catch (e) {
      _error = e.toString();
      return false; // Failed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.verifyOtp(email, otp);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
