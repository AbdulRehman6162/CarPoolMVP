import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email and we’ll send you a reset link.'),
            const SizedBox(height: 8),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'you@example.com'),
            ),
            const SizedBox(height: 12),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
            if (_sent)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Reset email sent. Please check your inbox.'),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'Send reset link',
                loading: auth.isLoading,
                onPressed: () async {
                  final email = _emailCtrl.text.trim();
                  final ok = await auth.requestPasswordReset(email);
                  if (!mounted) return;
                  if (ok) setState(() => _sent = true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
