import '../core/error/failure.dart';
import '../core/platform/biometric_auth.dart';
import '../core/result/result.dart';

/// Default biometric implementation that does nothing.
/// Keeps the app compiling on platforms where biometrics are not configured yet.
class NoopBiometricAuth implements BiometricAuth {
  @override
  Future<Result<void>> authenticate({required String reason}) async {
    return const FailureResult(UnsupportedFailure(userMessage: 'Biometric login is not available yet.'));
  }

  @override
  Future<Result<bool>> isSupported() async {
    return const Success(false);
  }
}
