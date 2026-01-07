import '../core/platform/secure_kv_store.dart';

/// In-memory implementation of [SecureKvStore].
///
/// NOTE: This is **NOT** secure storage; it's a development stub that keeps the
/// architecture DIP-friendly. Swap it in DI with a real secure implementation
/// (Keychain/Keystore) without touching domain/presentation.
class InMemorySecureKvStore implements SecureKvStore {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _store.clear();
  }
}
