import 'package:flutter/foundation.dart';

import 'auth_flow_state.dart';

/// App-level authentication flow state.
///
/// Keeps routing guards decoupled from feature presentation providers (DIP).
/// Auth feature can request gates (OTP/email verify/password update) while the
/// router only depends on this core provider.
class AuthFlowProvider extends ChangeNotifier {
  AuthGate _gate = AuthGate.none;
  OtpChallenge? _otpChallenge;
  String? _verificationEmail;

  AuthGate get gate => _gate;
  OtpChallenge? get otpChallenge => _otpChallenge;
  String? get verificationEmail => _verificationEmail;

  bool get needsOtp => _gate == AuthGate.otpVerification && _otpChallenge != null;
  bool get needsEmailVerification =>
      _gate == AuthGate.emailVerification && _verificationEmail != null;
  bool get needsPasswordUpdate => _gate == AuthGate.passwordUpdate;

  void requireOtp(OtpChallenge challenge) {
    _gate = AuthGate.otpVerification;
    _otpChallenge = challenge;
    notifyListeners();
  }

  void clearOtp() {
    if (_gate == AuthGate.otpVerification || _otpChallenge != null) {
      _otpChallenge = null;
      if (_gate == AuthGate.otpVerification) _gate = AuthGate.none;
      notifyListeners();
    }
  }

  void requireEmailVerification(String email) {
    _gate = AuthGate.emailVerification;
    _verificationEmail = email;
    notifyListeners();
  }

  void clearEmailVerification() {
    if (_gate == AuthGate.emailVerification || _verificationEmail != null) {
      _verificationEmail = null;
      if (_gate == AuthGate.emailVerification) _gate = AuthGate.none;
      notifyListeners();
    }
  }

  void requirePasswordUpdate() {
    _gate = AuthGate.passwordUpdate;
    notifyListeners();
  }

  void clearPasswordUpdate() {
    if (_gate == AuthGate.passwordUpdate) {
      _gate = AuthGate.none;
      notifyListeners();
    }
  }

  void clearAll() {
    _gate = AuthGate.none;
    _otpChallenge = null;
    _verificationEmail = null;
    notifyListeners();
  }
}
