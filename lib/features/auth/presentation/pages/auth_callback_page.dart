import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

/// Handles OAuth redirect callbacks.
///
/// Keep this page thin (SRP): it just attempts to let Supabase consume the deep link and then
/// relies on authStateChanges + router guards to take the user to the right destination.
class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handle();
  }

  Future<void> _handle() async {
    // Best-effort; different Supabase versions expose slightly different APIs.
    // This keeps compilation stable without hard-coupling to a specific method signature.
    try {
      final client = sb.Supabase.instance.client;
      final auth = client.auth;
      // ignore: avoid_dynamic_calls
      await (auth as dynamic).getSessionFromUrl(Uri.base);
    } catch (_) {
      // Ignore and rely on authStateChanges if the session was established by the SDK.
    }

    if (!mounted) return;
    // Router redirect logic will decide final route based on session/auth flow.
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
