import 'package:flutter/material.dart';
import '../../../core/design_system/tokens.dart';
import '../../../core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';

class BookingConfirmedPage extends StatelessWidget {
  const BookingConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.check_circle, size: 96, color: Colors.green.shade500),
            const SizedBox(height: 16),
            Text('Booking Confirmed!',
                style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            const Text(
                'You will receive a notification when the driver starts the trip.',
                textAlign: TextAlign.center),
            const Spacer(),
            SizedBox(
                width: double.infinity,
                child: AppButton.primary('View My Rides',
                    onPressed: () => context.go('/'))),
            const SizedBox(height: AppTokens.space3),
            SizedBox(
                width: double.infinity,
                child: AppButton.secondary('Back to Home',
                    onPressed: () => context.go('/'))),
          ],
        ),
      ),
    );
  }
}
