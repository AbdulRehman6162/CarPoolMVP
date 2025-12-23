import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpCtrl = TextEditingController(text: "1234"); // Pre-filled for demo

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.shield_outlined, size: 64, color: AppTokens.brand),
            const SizedBox(height: 24),
            Text('Enter Verification Code', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('We have sent a 4-digit code to\n${widget.email}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),

            // Simplified OTP Input (One box for now, can be split later)
            TextField(
              controller: _otpCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: "",
                hintText: "0000",
              ),
            ),

            const SizedBox(height: 32),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: AppTokens.error)),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'Verify',
                loading: auth.isLoading,
                onPressed: () async {
                  final success = await auth.verifyOtp(widget.email, _otpCtrl.text);
                  if (success && context.mounted) {
                    context.go('/'); // Success! Go Home
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