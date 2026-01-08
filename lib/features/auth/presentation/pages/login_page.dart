import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.from});

  final String? from;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTokens.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo Placeholder
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppTokens.brand.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.directions_car, size: 40, color: AppTokens.brand),
              ),
              const SizedBox(height: 24),
              Text(
                "Let's get you moving",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTokens.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Social Buttons (Visual Only for now)
              _SocialButton(label: 'Continue with Google', icon: Icons.g_mobiledata),
              const SizedBox(height: 12),
              _SocialButton(label: 'Continue with Apple', icon: Icons.apple),
              const SizedBox(height: 12),
              _SocialButton(label: 'Continue with Phone', icon: Icons.phone, onPressed: () {
                final from = widget.from;
                final qp = from == null ? '' : '?from=${Uri.encodeComponent(from)}';
                context.push('/phone-login$qp');
              }),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Row(children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("or", style: TextStyle(color: Colors.grey))),
                  Expanded(child: Divider()),
                ]),
              ),

              // Form
              if (auth.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: AppTokens.error.withOpacity(0.1),
                  child: Text(auth.error!, style: const TextStyle(color: AppTokens.error)),
                ),

              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email or Phone Number'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push('/forgot-password');
                  },
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  'Login',
                  loading: auth.isLoading,
                  onPressed: () async {
                    final success = await auth.login(_emailCtrl.text, _passCtrl.text);
                    if (success && context.mounted) {
                      final target = widget.from;
                      context.go((target != null && target.isNotEmpty) ? target : '/');
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => context.push('/signup'),
                    child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: AppTokens.brand)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  const _SocialButton({required this.label, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppTokens.text),
      label: Text(label, style: const TextStyle(color: AppTokens.text)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppTokens.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}