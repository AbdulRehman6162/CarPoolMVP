import 'package:flutter/material.dart';

import '../../domain/entities/my_ride.dart';
import '../utils/my_ride_ui_extensions.dart';
import '../../domain/entities/my_ride_role.dart';
import '../../domain/entities/my_ride_status.dart';

class MyRideCard extends StatelessWidget {
  final MyRide ride;
  final VoidCallback onTap;

  const MyRideCard({
    super.key,
    required this.ride,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData roleIcon;
    String roleLabel;
    switch (ride.role) {
      case MyRideRole.driver:
        roleIcon = Icons.directions_car;
        roleLabel = 'As driver';
        break;
      case MyRideRole.passenger:
        roleIcon = Icons.airline_seat_recline_normal;
        roleLabel = 'As passenger';
        break;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, size: 18, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(_formatDate(ride.departureTime), style: theme.textTheme.titleSmall),
                  ),
                  _StatusPill(text: ride.status.label),
                ],
              ),
              const SizedBox(height: 10),
              Text('${ride.fromCity} → ${ride.toCity}', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('${ride.formattedDuration} • PKR ${ride.pricePerSeat.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(roleIcon, size: 18),
                  const SizedBox(width: 6),
                  Text(roleLabel),
                  const Spacer(),
                  if (ride.role == MyRideRole.passenger) ...[
                    const Icon(Icons.verified, size: 16),
                    const SizedBox(width: 4),
                    Text(ride.driver.name, style: theme.textTheme.bodyMedium),
                  ] else ...[
                    Text('${ride.seatsBooked}/${ride.seatsTotal} seats booked',
                        style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dt.weekday - 1];
    return '$wd ${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}';
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
