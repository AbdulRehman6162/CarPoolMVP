import '../entities/auth_user.dart';

abstract class AuthRepository {
  /// Returns the current logged-in user, or null if guest.
  Future<AuthUser?> getCurrentUser();

  /// Logs in with email and password.
  Future<AuthUser> login(String email, String password);

  /// Registers a new user.
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Verifies the OTP code (step 2 of signup).
  Future<AuthUser> verifyOtp(String email, String otp);

  /// Logs the user out.
  Future<void> logout();

  /// A stream to listen to auth state changes (Logged In <-> Logged Out).
  Stream<AuthUser?> get authStateChanges;
}