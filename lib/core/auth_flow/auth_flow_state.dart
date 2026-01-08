enum AuthGate {
  none,
  otpVerification,
  emailVerification,
  passwordUpdate,
}

enum OtpTargetType { email, phone }

class OtpChallenge {
  final OtpTargetType type;
  final String target; // email or phone (E.164)
  const OtpChallenge({required this.type, required this.target});
}
