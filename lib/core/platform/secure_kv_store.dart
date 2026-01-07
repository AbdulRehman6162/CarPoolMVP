abstract class SecureKvStore {
  /// Reads the value for [key], or null if missing.
  Future<String?> read(String key);

  /// Writes [value] for [key].
  Future<void> write({required String key, required String value});

  /// Deletes the value for [key].
  Future<void> delete(String key);

  /// Clears all stored keys (optional; may be unsupported by some implementations).
  Future<void> deleteAll();
}
