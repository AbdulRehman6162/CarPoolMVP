import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../application/usecases/get_current_user_usecase.dart';
import '../../application/usecases/login_usecase.dart';
import '../../application/usecases/sign_out_usecase.dart';
import '../../application/usecases/signup_usecase.dart';
import '../../application/usecases/verify_otp_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  final GetCurrentUserUseCase _getCurrentUser;
  final LoginUseCase _login;
  final SignupUseCase _signup;
  final VerifyOtpUseCase _verifyOtp;
  final SignOutUseCase _signOut;

  late final StreamSubscription<AuthUser?> _sub;

  AuthUser? _user;
  bool _isLoading = false;
  Failure? _failure;
  bool _isInitialized = false;

  AuthProvider(this._repository)
      : _getCurrentUser = GetCurrentUserUseCase(_repository),
        _login = LoginUseCase(_repository),
        _signup = SignupUseCase(_repository),
        _verifyOtp = VerifyOtpUseCase(_repository),
        _signOut = SignOutUseCase(_repository) {
    // Listen to repository changes (e.g., session expiry)
    _sub = _repository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final res = await _getCurrentUser();
    res.when(
      success: (u) => _user = u,
      failure: (_) {},
    );

    _isInitialized = true;
    notifyListeners();
  }

  AuthUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  Failure? get failure => _failure;
  String? get error => _failure?.userMessage;
  bool get isInitialized => _isInitialized;

  void clearError() {
    _failure = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _login(email: email, password: password);
    _isLoading = false;

    final ok = res.when(
      success: (_) => true,
      failure: (f) {
        _failure = f;
        return false;
      },
    );

    notifyListeners();
    return ok;
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _signup(name: name, email: email, password: password);
    _isLoading = false;

    final ok = res.when(
      success: (_) => true,
      failure: (f) {
        _failure = f;
        return false;
      },
    );

    notifyListeners();
    return ok;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _verifyOtp(email: email, otp: otp);
    _isLoading = false;

    final ok = res.when(
      success: (_) => true,
      failure: (f) {
        _failure = f;
        return false;
      },
    );

    notifyListeners();
    return ok;
  }

  Future<void> logout() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _signOut();
    _isLoading = false;

    res.when(
      success: (_) {},
      failure: (f) => _failure = f,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

