import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/session_provider.dart';

/// Placeholder for the Post Ride flow.
/// Guests can start the flow, but publishing should require auth (to be enforced later at publish).
class PostRidePage extends StatelessWidget {
  const PostRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SessionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Draft your ride details here. Publishing will require login and vehicle details.',
            ),
            const SizedBox(height: 16),
            if (!auth.isAuthenticated)
              Card(
                child: ListTile(
                  title: const Text('Not logged in'),
                  subtitle: const Text('You can continue as guest, but you will need to login to publish.'),
                  trailing: TextButton(
                    onPressed: () => context.go('/login?from=/post-ride'),
                    child: const Text('Login'),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text('TODO: Implement Post Ride wizard steps.'),
          ],
        ),
      ),
    );
  }
}
