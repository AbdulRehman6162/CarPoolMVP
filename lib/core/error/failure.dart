abstract class Failure implements Exception {
  final String code;

  /// Safe for user display (localize later).
  final String userMessage;

  /// Useful for logging/crash reporting.
  final String? debugMessage;

  const Failure({
    required this.code,
    required this.userMessage,
    this.debugMessage,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? debugMessage})
      : super(
          code: 'unknown',
          userMessage: 'Something went wrong. Please try again.',
          debugMessage: debugMessage,
        );
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? debugMessage})
      : super(
          code: 'network',
          userMessage: 'Network error. Please check your internet and try again.',
          debugMessage: debugMessage,
        );
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String userMessage, String? debugMessage})
      : super(
          code: 'validation',
          userMessage: userMessage,
          debugMessage: debugMessage,
        );
}

class AuthFailure extends Failure {
  const AuthFailure({required String userMessage, String? debugMessage})
      : super(
          code: 'auth',
          userMessage: userMessage,
          debugMessage: debugMessage,
        );
}

class NotImplementedFailure extends Failure {
  const NotImplementedFailure({String? debugMessage})
      : super(
          code: 'not_implemented',
          userMessage: 'This feature is not available yet.',
          debugMessage: debugMessage,
        );
}

class UnsupportedFailure extends Failure {
  const UnsupportedFailure({String? userMessage, String? debugMessage})
      : super(
          code: 'unsupported',
          userMessage: userMessage ?? 'This feature is not supported on this device.',
          debugMessage: debugMessage,
        );
}

