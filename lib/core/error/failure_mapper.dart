import 'failure.dart';

class FailureMapper {
  static Failure from(Object error, [StackTrace? st]) {
    if (error is Failure) return error;
    // Add richer mappings as you integrate Supabase/Firebase exceptions.
    final msg = error.toString();

    if (msg.contains('SocketException') ||
        msg.contains('Failed host lookup') ||
        msg.contains('Connection failed')) {
      return NetworkFailure(debugMessage: msg);
    }

    if (msg.toLowerCase().contains('invalid') ||
        msg.toLowerCase().contains('required')) {
      return ValidationFailure(
        userMessage: 'Please check your input and try again.',
        debugMessage: msg,
      );
    }

    if (msg.toLowerCase().contains('auth') ||
        msg.toLowerCase().contains('login') ||
        msg.toLowerCase().contains('password') ||
        msg.toLowerCase().contains('otp')) {
      return AuthFailure(
        userMessage: 'Unable to authenticate. Please try again.',
        debugMessage: msg,
      );
    }

    return UnknownFailure(debugMessage: msg);
  }
}

