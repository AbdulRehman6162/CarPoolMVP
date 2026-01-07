import 'dart:convert';

import '../../../../core/platform/secure_kv_store.dart';
import '../models/auth_user_model.dart';

class AuthLocalDataSource {
  static const String _userKey = 'auth.current_user';

  final SecureKvStore _store;

  AuthLocalDataSource(this._store);

  Future<AuthUserModel?> getUser() async {
    final raw = await _store.read(_userKey);
    if (raw == null || raw.isEmpty) return null;

    final jsonMap = json.decode(raw) as Map<String, dynamic>;
    return AuthUserModel.fromJson(jsonMap);
  }

  Future<void> saveUser(AuthUserModel user) async {
    final raw = json.encode(user.toJson());
    await _store.write(key: _userKey, value: raw);
  }


  /// Clears any locally persisted auth session/user.
  Future<void> clear() async {
    await clearUser();
  }
  Future<void> clearUser() async {
    await _store.delete(_userKey);
  }
}
