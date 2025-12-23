import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/booking_status.dart';
import '../provider/booking_provider.dart';

class BookingResultPage extends StatelessWidget {
  const BookingResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        final result = provider.result;
        if (result == null) {
          return const Scaffold(
            body: Center(child: Text('No booking result')),
          );
        }

        String title;
        IconData icon;
        Color? color;

        if (result.status == BookingStatus.confirmed) {
          title = 'Booking confirmed';
          icon = Icons.check_circle;
          color = Colors.green;
        } else if (result.status == BookingStatus.pendingDriver) {
          title = 'Request sent to driver';
          icon = Icons.access_time;
          color = Colors.orange;
        } else {
          title = 'Booking declined';
          icon = Icons.cancel;
          color = Colors.red;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Booking status'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 64, color: color),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: const Text('Back to search'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
