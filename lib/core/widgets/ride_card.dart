
import 'package:flutter/material.dart';
import '../design_system/tokens.dart';
import 'app_button.dart';
import 'app_avatar.dart';

class Ride {
  final String driver;
  final String from;
  final String to;
  final String time; // 24h string for simplicity
  final int seats;
  final int price; // PKR
  final String phone;
  final String? avatarUrl;
  const Ride({required this.driver, required this.from, required this.to, required this.time, required this.seats, required this.price, required this.phone, this.avatarUrl});
}

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onRequest;
  const RideCard({super.key, required this.ride, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusXl),
        border: Border.all(color: AppTokens.outline.withOpacity(0.4)),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AppAvatar(initials: ride.driver, imageUrl: ride.avatarUrl),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${ride.from} → ${ride.to}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('${ride.time} • ${ride.seats} seats • PKR ${ride.price}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.8))),
            ])),
            const SizedBox(width: 12),
            AppButton.primary('Request', onPressed: onRequest),
          ],
        ),
      ),
    );
  }
}
