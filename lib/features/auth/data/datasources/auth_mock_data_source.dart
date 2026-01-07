import 'auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

/// Mock remote implementation used for MVP wiring.
/// Replace with SOAP/REST implementation later without touching domain/presentation.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Stream<AuthUserModel?> get authStateChanges => const Stream<AuthUserModel?>.empty();

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    return null;
  }


  @override
  Future<AuthUserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AuthUserModel(
      id: 'u123',
      email: email,
      name: 'John Doe',
    );
  }

  @override
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this triggers OTP send.
  }

  @override
  Future<AuthUserModel> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AuthUserModel(
      id: 'u456',
      email: email,
      name: 'New User',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
