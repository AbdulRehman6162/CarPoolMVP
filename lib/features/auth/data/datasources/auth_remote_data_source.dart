import '../../domain/entities/auth_credential.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  /// Emits auth user changes as observed by the remote auth provider.
  ///
  /// - Emits a user when a session becomes available
  /// - Emits null when the session ends / user signs out
  Stream<AuthUserModel?> get authStateChanges;

  /// Returns current remote user if a valid session exists.
  Future<AuthUserModel?> getCurrentUser();

  Future<AuthUserModel> login(String email, String password);

  /// Starts signup flow.
  ///
  /// Depending on provider configuration, this might:
  /// - create a session immediately, or
  /// - send a verification email / OTP and require [verifyOtp].
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Completes OTP / verification step (when enabled) for email.
  Future<AuthUserModel> verifyOtp(String email, String otp);

  /// Requests a phone OTP via the preferred channel.
  ///
  /// For Pakistani market, preferred is WhatsApp with SMS fallback.
  /// Not all providers support WhatsApp; in that case, implementations may throw
  /// [UnsupportedError] so callers can fall back to SMS.
  Future<void> requestPhoneOtp({
    required String phoneE164,
    required OtpChannel preferredChannel,
  });

  /// Verifies phone OTP and returns an authenticated user model.
  Future<AuthUserModel> verifyPhoneOtp({
    required String phoneE164,
    required String code,
  });

  /// Requests a password reset email (magic link).
  Future<void> requestPasswordReset(String email);

  /// Updates the password for the current authenticated user.
  Future<void> changePassword(String newPassword);

  /// Resends a signup verification email.
  Future<void> resendEmailVerification(String email);

  /// Signs out from the remote provider.
  Future<void> logout();
}
