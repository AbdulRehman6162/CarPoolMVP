enum OAuthProvider { google, apple, linkedin }

enum OtpChannel { whatsapp, sms, email }

sealed class AuthCredential {
  const AuthCredential();
}

class EmailPasswordLoginCredential extends AuthCredential {
  final String email;
  final String password;
  const EmailPasswordLoginCredential(this.email, this.password);
}

class EmailPasswordSignupCredential extends AuthCredential {
  final String name;
  final String email;
  final String password;
  const EmailPasswordSignupCredential({
    required this.name,
    required this.email,
    required this.password,
  });
}

class OtpVerifyCredential extends AuthCredential {
  final String email;
  final String otp;
  const OtpVerifyCredential(this.email, this.otp);
}

class OAuthSignInCredential extends AuthCredential {
  final OAuthProvider provider;
  const OAuthSignInCredential(this.provider);
}

class PhoneOtpStartCredential extends AuthCredential {
  final String phoneE164;
  final OtpChannel preferredChannel;
  const PhoneOtpStartCredential(this.phoneE164, {required this.preferredChannel});
}

class PhoneOtpVerifyCredential extends AuthCredential {
  final String phoneE164;
  final String code;
  const PhoneOtpVerifyCredential(this.phoneE164, this.code);
}

