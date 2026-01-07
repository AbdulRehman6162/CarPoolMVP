import '../entities/auth_credential.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  /// Returns the current logged-in user, or null if guest.
  Future<AuthUser?> getCurrentUser();

  /// Sign in using any supported credential (email/password, OAuth, OTP etc).
  Future<AuthUser> signIn(AuthCredential credential);

  /// Start signup using credential (e.g. email/password signup).
  Future<void> signUp(AuthCredential credential);

  /// Verify OTP (step 2 of signup or OTP login).
  Future<AuthUser> verifyOtp(OtpVerifyCredential credential);

  /// Logs the user out.
  Future<void> signOut();

  /// A stream to listen to auth state changes (Logged In <-> Logged Out).
  Stream<AuthUser?> get authStateChanges;
}

