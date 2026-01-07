import 'dart:async';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthUser? _currentUser;
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();

  StreamSubscription<AuthUserModel?>? _remoteSub;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local {
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
  Future<AuthUser> login(String email, String password) async {
    final model = await _remote.login(email, password);
    await _persistAndEmit(model);
    return model.toEntity();
  }

  @override
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await _remote.signup(name: name, email: email, password: password);
  }

  @override
  Future<AuthUser> verifyOtp(String email, String otp) async {
    final model = await _remote.verifyOtp(email, otp);
    await _persistAndEmit(model);
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    // Remote sign-out first (may trigger remote authStateChanges).
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

  /// Not part of domain abstraction; owned by composition root (DI).
  void dispose() {
    _remoteSub?.cancel();
    _controller.close();
  }
}
