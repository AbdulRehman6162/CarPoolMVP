import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class MyRidesPage extends StatelessWidget {
  const MyRidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your rides')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please login to view your rides.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/login?from=/my-rides'),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return  Scaffold(
      appBar: AppBar(title: Text('Your rides')),
      body: Center(child: Text('TODO: Implement My Rides list (driver & passenger).')),
    );
  }
}
