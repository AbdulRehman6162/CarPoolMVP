import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth_flow/auth_flow_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/phone_login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/update_password_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';

List<RouteBase> authRoutes() => [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return LoginPage(from: from);
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/phone-login',
        name: 'phone-login',
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return PhoneLoginPage(from: from);
        },
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final typeStr = state.uri.queryParameters['type'];
          final target = state.uri.queryParameters['target'];
          final from = state.uri.queryParameters['from'];

          if (typeStr == null || target == null) {
            return const _MissingOtpArgs();
          }

          final type =
              typeStr == 'phone' ? OtpTargetType.phone : OtpTargetType.email;

          return OtpVerificationPage(type: type, target: target, from: from);
        },
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          if (email == null || email.isEmpty) return const _MissingEmailArgs();
          return VerifyEmailPage(email: email);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/update-password',
        name: 'update-password',
        builder: (context, state) => const UpdatePasswordPage(),
      ),
    ];

class _MissingEmailArgs extends StatelessWidget {
  const _MissingEmailArgs();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Verify Email requires an email.

'
            "Fix: navigate to '/verify-email?email=you@example.com'",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _MissingOtpArgs extends StatelessWidget {
  const _MissingOtpArgs();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'OTP Verification requires query params.

'
            "Fix: navigate to '/otp-verification?type=email&target=you@example.com'",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
