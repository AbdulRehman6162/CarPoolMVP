import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/auth_flow/auth_flow_state.dart';
import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class OtpVerificationPage extends StatefulWidget {
  final OtpTargetType type;
  final String target;
  final String? from;

  const OtpVerificationPage({
    super.key,
    required this.type,
    required this.target,
    this.from,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final label = widget.type == OtpTargetType.phone ? 'phone' : 'email';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the code sent to your $label:'),
            const SizedBox(height: 6),
            Text(
              widget.target,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '123456'),
            ),
            const SizedBox(height: 18),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'Verify',
                loading: auth.isLoading,
                onPressed: () async {
                  final code = _otpCtrl.text.trim();
                  final ok = widget.type == OtpTargetType.phone
                      ? await auth.verifyPhoneOtp(widget.target, code)
                      : await auth.verifyOtp(widget.target, code);

                  if (!context.mounted) return;
                  if (ok) {
                    context.go(widget.from ?? '/');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
