import 'dart:async';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Simulating a local "Session"
  AuthUser? _currentUser;
  final _controller = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<AuthUser?> getCurrentUser() async {
    // In a real app, you would check SharedPreferences/SecureStorage here
    return _currentUser;
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network

    // Mock Validation
    if (email.contains('error')) {
      throw Exception('User not found');
    }

    _currentUser = const AuthUser(
      id: 'u123',
      email: 'demo@carpool.com',
      name: 'Ali Khan',
      photoUrl: 'https://i.pravatar.cc/300',
    );

    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> signup({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    // In real flow, this triggers an SMS/Email. Here we just succeed.
  }

  @override
  Future<AuthUser> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp != "1234") throw Exception("Invalid OTP Code");

    // Success after OTP
    _currentUser = AuthUser(
      id: 'u456',
      email: email,
      name: 'New User',
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _controller.add(null);
  }
}