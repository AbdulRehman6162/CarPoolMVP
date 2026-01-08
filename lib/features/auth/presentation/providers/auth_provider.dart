import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/auth_flow/auth_flow_provider.dart';
import '../../../../core/auth_flow/auth_flow_state.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/platform/biometric_auth.dart';
import '../../../../core/result/result.dart';
import '../../application/usecases/change_password_usecase.dart';
import '../../application/usecases/get_current_user_usecase.dart';
import '../../application/usecases/login_usecase.dart';
import '../../application/usecases/request_password_reset_usecase.dart';
import '../../application/usecases/request_phone_otp_usecase.dart';
import '../../application/usecases/resend_email_verification_usecase.dart';
import '../../application/usecases/sign_out_usecase.dart';
import '../../application/usecases/signup_usecase.dart';
import '../../application/usecases/verify_otp_usecase.dart';
import '../../application/usecases/verify_phone_otp_usecase.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  final AuthFlowProvider _authFlow;
  final BiometricAuth _biometricAuth;

  late final StreamSubscription<AuthUser?> _sub;

  late final GetCurrentUserUseCase _getCurrentUser;
  late final LoginUseCase _login;
  late final SignupUseCase _signup;
  late final VerifyOtpUseCase _verifyOtp;
  late final VerifyPhoneOtpUseCase _verifyPhoneOtp;
  late final RequestPhoneOtpUseCase _requestPhoneOtp;
  late final SignOutUseCase _signOut;
  late final RequestPasswordResetUseCase _requestPasswordReset;
  late final ChangePasswordUseCase _changePassword;
  late final ResendEmailVerificationUseCase _resendEmailVerification;

  AuthUser? _user;
  bool _isLoading = false;
  Failure? _failure;
  bool _isInitialized = false;

  AuthProvider(
    this._repository, {
    required AuthFlowProvider authFlow,
    required BiometricAuth biometricAuth,
  })  : _authFlow = authFlow,
        _biometricAuth = biometricAuth,
        _getCurrentUser = GetCurrentUserUseCase(_repository),
        _login = LoginUseCase(_repository),
        _signup = SignupUseCase(_repository),
        _verifyOtp = VerifyOtpUseCase(_repository),
        _verifyPhoneOtp = VerifyPhoneOtpUseCase(_repository),
        _requestPhoneOtp = RequestPhoneOtpUseCase(_repository),
        _signOut = SignOutUseCase(_repository),
        _requestPasswordReset = RequestPasswordResetUseCase(_repository),
        _changePassword = ChangePasswordUseCase(_repository),
        _resendEmailVerification = ResendEmailVerificationUseCase(_repository) {
    // Listen to repository changes (e.g., session expiry)
    _sub = _repository.authStateChanges.listen((user) {
      _user = user;

      // If user becomes available, clear OTP gate.
      if (user != null) {
        _authFlow.clearOtp();
      }

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

  void setValidationError(String message) {
    _failure = ValidationFailure(userMessage: message);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _login(email: email, password: password);
    _isLoading = false;

    final ok = res.when(
      success: (_) {
        _authFlow.clearAll();
        return true;
      },
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
      success: (_) {
        // Many providers require email verification after signup.
        // We gate the UI and let user continue once session/verification updates.
        _authFlow.requireEmailVerification(email);
        return true;
      },
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
      success: (_) {
        _authFlow.clearOtp();
        return true;
      },
      failure: (f) {
        _failure = f;
        return false;
      },
    );

    notifyListeners();
    return ok;
  }

Future<bool> requestPhoneOtp(
  String phoneE164, {
  AuthOtpChannel preferred = AuthOtpChannel.whatsapp,
}) async {
  _isLoading = true;
  _failure = null;
  notifyListeners();

  Result<void> res = await _requestPhoneOtp(
    phoneE164: phoneE164,
    preferredChannel: preferred,
  );

  // WhatsApp preferred → fall back to SMS when unsupported.
  if (preferred == AuthOtpChannel.whatsapp &&
      res is FailureResult<void> &&
      (res.failure is UnsupportedFailure || res.failure is NotImplementedFailure)) {
    res = await _requestPhoneOtp(
      phoneE164: phoneE164,
      preferredChannel: AuthOtpChannel.sms,
    );
  }

  _isLoading = false;

  final ok = res.when(
    success: (_) {
      _authFlow.requireOtp(
        OtpChallenge(type: OtpTargetType.phone, target: phoneE164),
      );
      return true;
    },
    failure: (f) {
      _failure = f;
      return false;
    },
  );

  notifyListeners();
  return ok;
}
  Future<bool> verifyPhoneOtp(String phoneE164, String code) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _verifyPhoneOtp(phoneE164: phoneE164, code: code);
    _isLoading = false;

    final ok = res.when(
      success: (_) {
        _authFlow.clearOtp();
        _authFlow.clearEmailVerification();
        return true;
      },
      failure: (f) {
        _failure = f;
        return false;
      },
    );

    notifyListeners();
    return ok;
  }

  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _requestPasswordReset(email: email);
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

  Future<bool> changePassword(String newPassword) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _changePassword(newPassword: newPassword);
    _isLoading = false;

    final ok = res.when(
      success: (_) {
        _authFlow.clearPasswordUpdate();
        return true;
      },
      failure: (f) {
        _failure = f;
        return false;
      },
    );

    notifyListeners();
    return ok;
  }

  Future<void> resendEmailVerification(String email) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _resendEmailVerification(email: email);
    _isLoading = false;
    res.when(
      success: (_) {},
      failure: (f) => _failure = f,
    );

    notifyListeners();
  }

  /// Called when the user completes an external action (email verify / recovery link)
  /// and returns to the app.
  Future<bool> refreshAfterExternalAction() async {
    final res = await _getCurrentUser();
    return res.when(
      success: (u) {
        _user = u;
        _authFlow.clearEmailVerification();
        _authFlow.clearPasswordUpdate();
        notifyListeners();
        return true;
      },
      failure: (f) {
        _failure = f;
        notifyListeners();
        return false;
      },
    );
  }

  Future<void> signOut() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final res = await _signOut();
    _isLoading = false;

    res.when(
      success: (_) {
        _authFlow.clearAll();
      },
      failure: (f) => _failure = f,
    );

    notifyListeners();
  }

  Future<bool> biometricReauth() async {
    final supported = await _biometricAuth.isSupported();
    return supported.when(
      success: (isSupported) async {
        if (!isSupported) {
          _failure = const UnsupportedFailure();
          notifyListeners();
          return false;
        }
        final res = await _biometricAuth.authenticate(reason: 'Unlock Carpool');
        return res.when(
          success: (_) => true,
          failure: (f) {
            _failure = f;
            notifyListeners();
            return false;
          },
        );
      },
      failure: (f) {
        _failure = f;
        notifyListeners();
        return false;
      },
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
