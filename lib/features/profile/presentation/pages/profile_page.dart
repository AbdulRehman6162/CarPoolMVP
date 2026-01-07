import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/session_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SessionProvider>();

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Login to manage your profile.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/login?from=/profile'),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logged in as: ${auth.user?.email ?? ''}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await context.read<SessionProvider>().logout();
                if (context.mounted) context.go('/');
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 24),
            const Text('TODO: Implement profile editing.'),
          ],
        ),
      ),
    );
  }
}
