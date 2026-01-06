import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/platform/chat_launcher.dart';
import '../../domain/entities/my_ride.dart';
import '../../domain/entities/my_ride_role.dart';
import '../../domain/entities/my_ride_status.dart';

class MyRideDetailsPage extends StatelessWidget {
  final MyRide ride;
  final bool archivedMode;

  const MyRideDetailsPage({
    super.key,
    required this.ride,
    this.archivedMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(archivedMode ? 'Archived ride details' : 'Ride details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Header(ride: ride),
          const SizedBox(height: 16),
          _Addresses(ride: ride),
          const SizedBox(height: 16),
          _Pricing(ride: ride),
          const SizedBox(height: 16),
          if (archivedMode) ...[
            _ArchivedActions(ride: ride),
          ] else ...[
            if (ride.role == MyRideRole.driver) ...[
              _DriverSummary(ride: ride),
              const SizedBox(height: 12),
              Text('Your passengers', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _PassengersList(ride: ride),
              const SizedBox(height: 16),
              const _DriverActions(),
            ] else ...[
              _DriverInfo(ride: ride),
              const SizedBox(height: 16),
              _PassengerActions(ride: ride),
            ],
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final MyRide ride;
  const _Header({required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.schedule),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_formatDate(ride.departureTime), style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text('${ride.formattedDuration} estimated', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Text(ride.status.label, style: theme.textTheme.labelSmall),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dt.weekday - 1];
    return '$wd ${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}';
  }
}

class _Addresses extends StatelessWidget {
  final MyRide ride;
  const _Addresses({required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ride.fromCity, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(ride.fromAddress),
        const SizedBox(height: 12),
        Text(ride.toCity, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(ride.toAddress),
      ],
    );
  }
}

class _Pricing extends StatelessWidget {
  final MyRide ride;
  const _Pricing({required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleText = ride.role == MyRideRole.driver ? 'As driver' : 'As passenger';
    final roleIcon = ride.role == MyRideRole.driver ? Icons.directions_car : Icons.airline_seat_recline_normal;

    return Row(
      children: [
        Icon(roleIcon),
        const SizedBox(width: 8),
        Text(roleText, style: theme.textTheme.titleSmall),
        const Spacer(),
        Text('PKR ${ride.pricePerSeat.toStringAsFixed(0)}', style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _DriverSummary extends StatelessWidget {
  final MyRide ride;
  const _DriverSummary({required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${ride.seatsAvailable} seats available', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text('${ride.seatsBooked}/${ride.seatsTotal} seats booked', style: theme.textTheme.bodyMedium),
        if (ride.vehicleName != null) ...[
          const SizedBox(height: 6),
          Text('Vehicle: ${ride.vehicleName}', style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }
}

class _PassengersList extends StatelessWidget {
  final MyRide ride;
  const _PassengersList({required this.ride});

  @override
  Widget build(BuildContext context) {
    if (ride.passengers.isEmpty) {
      return const Text('No passengers booked yet.');
    }
    return Column(
      children: ride.passengers.map((p) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(p.user.name),
            subtitle: Text('${p.seatsBooked} seat(s) booked${p.note != null ? ' • ${p.note}' : ''}'),
          ),
        );
      }).toList(),
    );
  }
}

class _DriverActions extends StatelessWidget {
  const _DriverActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionTile(
          icon: Icons.checklist,
          title: 'Manage Booking Requests',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: Manage booking requests')),
            );
          },
        ),
        _ActionTile(
          icon: Icons.map,
          title: 'View Route',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: View route')),
            );
          },
        ),
        _ActionTile(
          icon: Icons.cancel,
          title: 'Cancel Ride',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: Cancel ride')),
            );
          },
        ),
      ],
    );
  }
}

class _DriverInfo extends StatelessWidget {
  final MyRide ride;
  const _DriverInfo({required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.verified),
        title: Text(ride.driver.name),
        subtitle: const Text('Driver'),
        trailing: Text('${ride.seatsTotal - ride.seatsAvailable} seats booked', style: theme.textTheme.bodySmall),
      ),
    );
  }
}

class _PassengerActions extends StatelessWidget {
  final MyRide ride;
  const _PassengerActions({required this.ride});

  @override
  Widget build(BuildContext context) {
    final launcher = context.read<ChatLauncher>();
    return Column(
      children: [
        _ActionTile(
          icon: Icons.chat,
          title: 'Contact Driver',
          onTap: () async {
            final ok = await launcher.openWhatsApp(
              phone: '923001234567',
              message: 'Hi ${ride.driver.name}, I am contacting you about ride ${ride.fromCity} → ${ride.toCity}.',
            );
            if (!context.mounted) return;
            if (!ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unable to open WhatsApp')),
              );
            }
          },
        ),
        _ActionTile(
          icon: Icons.route,
          title: 'View Route',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: View route')),
            );
          },
        ),
        _ActionTile(
          icon: Icons.cancel,
          title: 'Cancel Ride',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: Cancel booking')),
            );
          },
        ),
      ],
    );
  }
}

class _ArchivedActions extends StatelessWidget {
  final MyRide ride;
  const _ArchivedActions({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (ride.vehicleName != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_car),
              title: Text(ride.vehicleName!),
              subtitle: Text('${ride.seatsBooked} seats booked'),
            ),
          ),
        _ActionTile(
          icon: Icons.flag,
          title: 'Report Issue',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: Report issue')),
            );
          },
        ),
        _ActionTile(
          icon: Icons.support_agent,
          title: 'Contact Support',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: Contact support')),
            );
          },
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
