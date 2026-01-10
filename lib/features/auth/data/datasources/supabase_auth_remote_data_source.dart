import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/env/env.dart';
import '../../domain/entities/auth_event.dart';

import '../models/auth_user_model.dart';
import '../../domain/entities/auth_credential.dart';
import 'auth_remote_data_source.dart';

/// Supabase-backed implementation of [AuthRemoteDataSource].
///
/// Keeps Supabase dependency isolated to the data layer (Clean Architecture + DIP).
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final sb.SupabaseClient _client;

  SupabaseAuthRemoteDataSource(this._client);

  @override
  Stream<AuthUserModel?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((state) {
        final user = state.session?.user ?? _client.auth.currentUser;
        return user == null ? null : _mapUser(user);
      });

  @override
  Stream<AuthEventType> get authEvents => _client.auth.onAuthStateChange.map((state) {
        final name = state.event.toString().split('.').last;
        switch (name) {
          case 'initialSession':
            return AuthEventType.initialSession;
          case 'signedIn':
            return AuthEventType.signedIn;
          case 'signedOut':
            return AuthEventType.signedOut;
          case 'tokenRefreshed':
            return AuthEventType.tokenRefreshed;
          case 'userUpdated':
            return AuthEventType.userUpdated;
          case 'passwordRecovery':
            return AuthEventType.passwordRecovery;
          default:
            return AuthEventType.unknown;
        }
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

  sb.OtpType _otpTypeByName(String name) {
    for (final t in sb.OtpType.values) {
      if (t.name == name) return t;
    }
    // Fallback (keeps compilation safe across Supabase SDK versions).
    return sb.OtpType.values.first;
  }


  @override
  Future<void> startOAuthSignIn({
    required OAuthProvider provider,
    String? redirectTo,
  }) async {
    final target = redirectTo ?? (Env.authOAuthRedirectUrl.isNotEmpty ? Env.authOAuthRedirectUrl : null);
    final sbProvider = sb.OAuthProvider.values.firstWhere(
      (p) => p.name == provider.name,
      orElse: () => throw UnsupportedError('OAuth provider not supported: ${provider.name}'),
    );
    await _client.auth.signInWithOAuth(sbProvider, redirectTo: target);
  }

@override
Future<void> requestPhoneOtp({
  required String phoneE164,
  required AuthOtpChannel preferredChannel,
}) async {
  // Supabase supports SMS OTP. WhatsApp OTP is not supported natively.
  if (preferredChannel == AuthOtpChannel.whatsapp) {
    throw UnsupportedError('WhatsApp OTP not supported by Supabase');
  }

  await _client.auth.signInWithOtp(phone: phoneE164);
}

@override
Future<AuthUserModel> verifyPhoneOtp({
  required String phoneE164,
  required String code,
}) async {
  final res = await _client.auth.verifyOTP(
    phone: phoneE164,
    token: code,
    type: sb.OtpType.sms,
  );

  final user = res.user;
  if (user == null) {
    throw Exception('OTP verification failed.');
  }
  return _mapUser(user);
}

@override
Future<void> requestPasswordReset(String email) async {
  await _client.auth.resetPasswordForEmail(email);
}

@override
Future<void> changePassword(String newPassword) async {
  await _client.auth.updateUser(sb.UserAttributes(password: newPassword));
}

@override
Future<void> resendEmailVerification(String email) async {
  await _client.auth.resend(
    type: sb.OtpType.signup,
    email: email,
  );
}
  AuthUserModel _mapUser(sb.User user) {
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
      name: name.isNotEmpty ? name : (email.isNotEmpty ? email : 'sb.User'),
      phoneNumber: phone?.isEmpty == true ? null : phone,
      photoUrl: photoUrl?.isEmpty == true ? null : photoUrl,
    );
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
