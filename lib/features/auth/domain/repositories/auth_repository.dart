import '../entities/auth_credential.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  /// Returns the current logged-in user, or null if guest.
  Future<AuthUser?> getCurrentUser();

  /// Sign in using any supported credential (email/password, OAuth, OTP etc).
  Future<AuthUser> signIn(AuthCredential credential);

  /// Start signup using credential (e.g. email/password signup).
  Future<void> signUp(AuthCredential credential);

  /// Verify OTP for email-based flows (step 2 of signup or OTP login).
  Future<AuthUser> verifyOtp(OtpVerifyCredential credential);

  /// Requests a phone OTP (WhatsApp preferred, with SMS fallback).
  Future<void> requestPhoneOtp(PhoneOtpStartCredential credential);

  /// Verifies a phone OTP and returns the authenticated user.
  Future<AuthUser> verifyPhoneOtp(PhoneOtpVerifyCredential credential);

  /// Requests a password reset email (magic link).
  Future<void> requestPasswordReset(String email);

  /// Changes the password for the current authenticated user.
  Future<void> changePassword(String newPassword);

  /// Resends verification email for signup confirmation.
  Future<void> resendEmailVerification(String email);

  /// Logs the user out.
  Future<void> signOut();

  /// A stream to listen to auth state changes (Logged In <-> Logged Out).
  Stream<AuthUser?> get authStateChanges;
}
