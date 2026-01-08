import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../core/auth_flow/auth_flow_provider.dart';
import '../core/auth_flow/auth_flow_state.dart';
import '../core/session/session_provider.dart';
import 'routes/auth_routes.dart';
import 'routes/picker_routes.dart';
import 'routes/shell_routes.dart';

GoRouter createRouter({
  required SessionProvider session,
  required AuthFlowProvider authFlow,
}) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([session, authFlow]),
    redirect: (context, state) {
      // Let the app render while we bootstrap local cache + remote session.
      if (!session.isInitialized) return null;

      final path = state.uri.path;
      final isLoggedIn = session.isAuthenticated;

      final isLogin = path == '/login';
      final isSignup = path == '/signup';

      final isOtp = path == '/otp-verification';
      final isVerifyEmail = path == '/verify-email';
      final isForgotPassword = path == '/forgot-password';
      final isUpdatePassword = path == '/update-password';
      final isPhoneLogin = path == '/phone-login';

      // ---------------- Auth flow gates (OTP/email verification/password update) ----------------
      if (authFlow.needsPasswordUpdate && !isUpdatePassword) {
        return '/update-password';
      }

      if (authFlow.needsEmailVerification && !isVerifyEmail) {
        final email = Uri.encodeComponent(authFlow.verificationEmail!);
        return '/verify-email?email=$email';
      }

      if (authFlow.needsOtp && !isOtp) {
        final c = authFlow.otpChallenge!;
        final target = Uri.encodeComponent(c.target);
        final type = c.type == OtpTargetType.phone ? 'phone' : 'email';
        return '/otp-verification?type=$type&target=$target';
      }

      // ---------------- Protected areas ----------------
      final requiresAuth = path.startsWith('/my-rides') ||
          path.startsWith('/profile') ||
          path.startsWith('/post-ride');

      if (!isLoggedIn && requiresAuth) {
        final from = Uri.encodeComponent(state.uri.toString());
        return '/login?from=$from';
      }

      // If logged in, keep user out of auth screens (except password update/verify-email if gated).
      if (isLoggedIn && (isLogin || isSignup || isPhoneLogin || isForgotPassword)) {
        return '/';
      }

      return null;
    },
    routes: [
      ...authRoutes(),
      appShellRoute(),
      ...pickerRoutes(),
    ],
  );
}
