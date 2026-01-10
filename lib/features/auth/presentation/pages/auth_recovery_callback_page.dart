import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

/// Handles password recovery redirect callbacks.
///
/// Keep thin (SRP). We attempt to let Supabase parse the recovery link; routing guards will
/// then enforce update-password flow.
class AuthRecoveryCallbackPage extends StatefulWidget {
  const AuthRecoveryCallbackPage({super.key});

  @override
  State<AuthRecoveryCallbackPage> createState() => _AuthRecoveryCallbackPageState();
}

class _AuthRecoveryCallbackPageState extends State<AuthRecoveryCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handle();
  }

  Future<void> _handle() async {
    try {
      final client = sb.Supabase.instance.client;
      final auth = client.auth;
      // ignore: avoid_dynamic_calls
      await (auth as dynamic).getSessionFromUrl(Uri.base);
    } catch (_) {
      // Ignore and rely on authStateChanges + authEvents mapping.
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/update-password');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
