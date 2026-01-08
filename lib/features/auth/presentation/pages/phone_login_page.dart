import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class PhoneLoginPage extends StatefulWidget {
  final String? from;
  const PhoneLoginPage({super.key, this.from});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Continue with Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phone number (E.164 format, e.g. +92...)'),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+92XXXXXXXXXX',
              ),
            ),
            const SizedBox(height: 12),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'Send OTP',
                loading: auth.isLoading,
                onPressed: () async {
                  final phone = _phoneCtrl.text.trim();
                  final ok = await auth.requestPhoneOtp(phone);
                  if (!context.mounted) return;

                  if (ok) {
                    // Router guard will send the user to /otp-verification automatically.
                    context.go('/otp-verification?type=phone&target=${Uri.encodeComponent(phone)}'
                        '${widget.from != null ? '&from=${Uri.encodeComponent(widget.from!)}' : ''}');
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
