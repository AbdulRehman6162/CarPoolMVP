import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/platform/secure_kv_store.dart';

/// Production [SecureKvStore] backed by `flutter_secure_storage`.
///
/// Keeps storage plugin code out of domain/presentation (DIP).
class FlutterSecureKvStore implements SecureKvStore {
  final FlutterSecureStorage _storage;

  FlutterSecureKvStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
