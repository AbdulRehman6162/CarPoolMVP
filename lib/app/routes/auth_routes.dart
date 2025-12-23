import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';

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
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final email = state.extra as String?;
          if (email == null || email.isEmpty) {
            return const _MissingEmailErrorPage();
          }
          return OtpVerificationPage(email: email);
        },
      ),
    ];

class _MissingEmailErrorPage extends StatelessWidget {
  const _MissingEmailErrorPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'OTP Verification requires an email.\n\n'
            'Fix: Navigate using:\n'
            "context.push('/otp-verification', extra: email);",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
