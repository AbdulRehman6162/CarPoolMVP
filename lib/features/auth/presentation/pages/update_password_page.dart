import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Update password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a new password.'),
            const SizedBox(height: 8),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'New password'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Confirm password'),
            ),
            const SizedBox(height: 12),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'Save',
                loading: auth.isLoading,
                onPressed: () async {
                  final p1 = _passCtrl.text;
                  final p2 = _confirmCtrl.text;
                  if (p1.length < 8) {
                    auth.setValidationError('Password must be at least 8 characters.');
                    return;
                  }
                  if (p1 != p2) {
                    auth.setValidationError('Passwords do not match.');
                    return;
                  }

                  final ok = await auth.changePassword(p1);
                  if (!context.mounted) return;
                  if (ok) {
                    context.go('/');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
