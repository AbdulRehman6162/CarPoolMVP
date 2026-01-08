import '../../domain/entities/auth_credential.dart';
import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

/// Mock remote implementation used for MVP wiring.
/// Replace with real implementation later without touching domain/presentation.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Stream<AuthUserModel?> get authStateChanges =>
      const Stream<AuthUserModel?>.empty();

  @override
  Future<AuthUserModel?> getCurrentUser() async => null;

  @override
  Future<AuthUserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AuthUserModel(id: 'u123', email: email, name: 'Mock User');
  }

  @override
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<AuthUserModel> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AuthUserModel(id: 'u456', email: email, name: 'New User');
  }

  @override
  Future<void> requestPhoneOtp({
    required String phoneE164,
    required OtpChannel preferredChannel,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Future<AuthUserModel> verifyPhoneOtp({
    required String phoneE164,
    required String code,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AuthUserModel(
      id: 'u789',
      email: '',
      name: 'Phone User',
      phoneNumber: phoneE164,
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Future<void> changePassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Future<void> resendEmailVerification(String email) async {
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
