import 'dart:async';

import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';
import '../strategies/auth_strategy_registry.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final AuthStrategyRegistry _registry;

  AuthUser? _currentUser;
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();

  StreamSubscription<AuthUserModel?>? _remoteSub;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required AuthStrategyRegistry registry,
  })  : _remote = remote,
        _local = local,
        _registry = registry {
    // Keep repository state consistent with remote provider session changes.
    _remoteSub = _remote.authStateChanges.listen(
      (model) async {
        try {
          if (model == null) {
            await _local.clear();
            _currentUser = null;
            _controller.add(null);
            return;
          }
          await _persistAndEmit(model);
        } catch (_) {
          // Ignore remote stream errors to avoid crashing the app.
        }
      },
    );
  }

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<AuthUser?> getCurrentUser() async {
    final cached = await _local.getUser();
    _currentUser = cached?.toEntity();
    return _currentUser;
  }

  @override
  Future<AuthUser> signIn(AuthCredential credential) async {
    // Strategy may throw; upper layers convert to Failure.
    final user = await _registry.signIn(credential);
    // For email/password login: remote already emitted authStateChanges, but persist anyway for consistency.
    if (user == null) {
      throw StateError('Sign-in did not return a user for ${credential.runtimeType}');
    }
    // Persist from remote current user if available; otherwise persist minimal.
    final cached = await _local.getUser();
    if (cached == null) {
      // If datasource returned entity without model, we still want local session for fast bootstrap.
      // Keep it minimal: store via remote current user model by calling remote.getCurrentUser().
      final model = await _remote.getCurrentUser();
      if (model != null) {
        await _persistAndEmit(model);
        return model.toEntity();
      }
    }
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signUp(AuthCredential credential) async {
    await _registry.signUp(credential);
  }

  @override
  Future<AuthUser> verifyOtp(OtpVerifyCredential credential) async {
    final user = await _registry.signIn(credential);
    if (user == null) {
      throw StateError('OTP verify did not return a user');
    }
    final model = await _remote.getCurrentUser();
    if (model != null) {
      await _persistAndEmit(model);
    } else {
      _currentUser = user;
      _controller.add(user);
    }
    return user;
  }

@override
Future<void> requestPhoneOtp(PhoneOtpStartCredential credential) async {
  await _remote.requestPhoneOtp(
    phoneE164: credential.phoneE164,
    preferredChannel: credential.preferredChannel,
  );
}

@override
Future<AuthUser> verifyPhoneOtp(PhoneOtpVerifyCredential credential) async {
  final model = await _remote.verifyPhoneOtp(
    phoneE164: credential.phoneE164,
    code: credential.code,
  );
  await _persistAndEmit(model);
  return model.toEntity();
}

@override
Future<void> requestPasswordReset(String email) async {
  await _remote.requestPasswordReset(email);
}

@override
Future<void> changePassword(String newPassword) async {
  await _remote.changePassword(newPassword);
}

@override
Future<void> resendEmailVerification(String email) async {
  await _remote.resendEmailVerification(email);
}

  @override
  Future<void> signOut() async {
    await _remote.logout();
    await _local.clear();
    _currentUser = null;
    _controller.add(null);
  }

  Future<void> _persistAndEmit(AuthUserModel model) async {
    await _local.saveUser(model);
    _currentUser = model.toEntity();
    _controller.add(_currentUser);
  }

  void dispose() {
    _remoteSub?.cancel();
    _controller.close();
  }
}
