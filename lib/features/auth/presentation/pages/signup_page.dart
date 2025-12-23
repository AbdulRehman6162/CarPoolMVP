import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTokens.surface,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTokens.text,
                ),
              ),
              const SizedBox(height: 32),

              // Fields
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Enter your full name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email Address', hintText: 'Enter your email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', hintText: 'Create a password'),
              ),

              const SizedBox(height: 40),

              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
                ),

              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  'Sign Up',
                  loading: auth.isLoading,
                  onPressed: () async {
                    final success = await auth.signup(_nameCtrl.text, _emailCtrl.text, _passCtrl.text);
                    if (success && context.mounted) {
                      context.push('/otp-verification', extra: _emailCtrl.text);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}