import '../result/result.dart';

/// Abstraction for biometric re-auth.
///
/// This is used as a local unlock mechanism (NOT a backend login method).
/// Keep it behind an interface (DIP) so we can swap implementations without
/// changing domain/presentation code.
abstract class BiometricAuth {
  Future<Result<bool>> isSupported();

  /// Prompts the user for biometric authentication.
  Future<Result<void>> authenticate({required String reason});
}
