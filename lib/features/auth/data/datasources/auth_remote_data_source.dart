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
  /// Depending on provider configuration, this may:
  /// - create a session immediately, or
  /// - send a verification email / OTP and require [verifyOtp].
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Completes OTP / verification step (when enabled).
  Future<AuthUserModel> verifyOtp(String email, String otp);

  /// Signs out from the remote provider.
  Future<void> logout();
}
