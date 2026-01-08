import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class VerifyEmailPage extends StatelessWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('We sent a verification link to:
$email'),
            const SizedBox(height: 12),
            const Text('Open your email, verify your account, then return here.'),
            const SizedBox(height: 12),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.secondary(
                'Resend verification email',
                loading: auth.isLoading,
                onPressed: () async {
                  await auth.resendEmailVerification(email);
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'I have verified',
                loading: auth.isLoading,
                onPressed: () async {
                  final ok = await auth.refreshAfterExternalAction();
                  if (!context.mounted) return;
                  if (ok) context.go('/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
