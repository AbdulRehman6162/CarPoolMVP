import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

/// Supabase-backed implementation of [AuthRemoteDataSource].
///
/// Keeps Supabase dependency isolated to the data layer (Clean Architecture + DIP).
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient _client;

  SupabaseAuthRemoteDataSource(this._client);

  @override
  Stream<AuthUserModel?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((state) {
        final user = state.session?.user ?? _client.auth.currentUser;
        return user == null ? null : _mapUser(user);
      });

@override
  Future<AuthUserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }


  @override
  Future<AuthUserModel> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Login failed. Please check your credentials.');
    }
    return _mapUser(user);
  }

  @override
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: <String, dynamic>{
        'name': name,
      },
    );
  }

  @override
  Future<AuthUserModel> verifyOtp(String email, String otp) async {
    // Supabase supports multiple OTP types depending on project auth settings.
    // We try 'signup' first, then fall back to 'magiclink' when present.
    try {
      return await _verifyOtp(email: email, otp: otp, typeName: 'signup');
    } catch (_) {
      return await _verifyOtp(email: email, otp: otp, typeName: 'magiclink');
    }
  }

  Future<AuthUserModel> _verifyOtp({
    required String email,
    required String otp,
    required String typeName,
  }) async {
    final type = _otpTypeByName(typeName);

    final res = await _client.auth.verifyOTP(
      email: email,
      token: otp,
      type: type,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('OTP verification failed.');
    }
    return _mapUser(user);
  }

  OtpType _otpTypeByName(String name) {
    for (final t in OtpType.values) {
      if (t.name == name) return t;
    }
    // Fallback (keeps compilation safe across Supabase SDK versions).
    return OtpType.values.first;
  }

  AuthUserModel _mapUser(User user) {
    final email = user.email ?? '';
    final meta = user.userMetadata ?? const <String, dynamic>{};

    final name = (meta['name'] ??
            meta['full_name'] ??
            meta['display_name'] ??
            meta['username'] ??
            '')
        .toString()
        .trim();

    final phone = (user.phone ?? meta['phone']?.toString())?.trim();
    final photoUrl = (meta['avatar_url'] ?? meta['photo_url'] ?? meta['photoUrl'])
        ?.toString()
        .trim();

    return AuthUserModel(
      id: user.id,
      email: email,
      name: name.isNotEmpty ? name : (email.isNotEmpty ? email : 'User'),
      phoneNumber: phone?.isEmpty == true ? null : phone,
      photoUrl: photoUrl?.isEmpty == true ? null : photoUrl,
    );
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
