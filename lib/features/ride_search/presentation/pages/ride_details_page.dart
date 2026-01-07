import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/tokens.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/driver.dart';
import '../provider/booking_provider.dart';

class RideDetailsPage extends StatelessWidget {
  final Ride ride;

  const RideDetailsPage({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    // Calculate approximate arrival time (assuming 4 hours for demo purposes)
    // In a real app, this should come from the backend/entity.
    final arrivalTime = ride.departureTime.add(const Duration(hours: 4));

    return Scaffold(
      backgroundColor: AppTokens.surface,
      appBar: AppBar(
        backgroundColor: AppTokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTokens.brand),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Ride Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTokens.text,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTokens.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTokens.space4),
                    _DateHeader(date: ride.departureTime),
                    const SizedBox(height: AppTokens.space6),
                    _TimelineSection(
                      departureTime: ride.departureTime,
                      arrivalTime: arrivalTime,
                      fromCity: ride.fromCity,
                      toCity: ride.toCity,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppTokens.space6),
                      child: Divider(color: AppTokens.outline),
                    ),
                    _PriceSection(price: ride.price),
                    const SizedBox(height: AppTokens.space6),
                    _DriverSection(
                        driver: ride.driver, isInstant: ride.isInstantBooking),
                    const SizedBox(height: 100), // Spacing for the fixed footer
                  ],
                ),
              ),
            ),
            _BookingFooter(ride: ride),
          ],
        ),
      ),
    );
  }
}

/// Displays the formatted date header.
class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    // Basic date formatting
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final d = date.toLocal();
    final dateStr =
        '${weekDays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';

    return Text(
      dateStr,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTokens.brand,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Displays the vertical timeline of the ride.
class _TimelineSection extends StatelessWidget {
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String fromCity;
  final String toCity;

  const _TimelineSection({
    required this.departureTime,
    required this.arrivalTime,
    required this.fromCity,
    required this.toCity,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time Column
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(departureTime),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTokens.text),
              ),
              Text(
                _formatTime(arrivalTime),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTokens.text),
              ),
            ],
          ),
          const SizedBox(width: AppTokens.space4),
          // Visual Line Column
          Column(
            children: [
              _TimelineDot(color: AppTokens.brand, isHollow: true),
              Expanded(
                child: Container(
                  width: 2,
                  color: AppTokens.brand,
                ),
              ),
              _TimelineDot(color: AppTokens.brand, isHollow: false),
            ],
          ),
          const SizedBox(width: AppTokens.space4),
          // Location Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LocationItem(city: fromCity, detail: 'Pick-up point'),
                const SizedBox(height: AppTokens.space6), // Minimum spacing
                _LocationItem(city: toCity, detail: 'Drop-off point'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _LocationItem extends StatelessWidget {
  final String city;
  final String detail;

  const _LocationItem({required this.city, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              city,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTokens.brand,
                  ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.map, size: 16, color: AppTokens.brand),
          ],
        ),
        Text(
          detail,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final Color color;
  final bool isHollow;

  const _TimelineDot({required this.color, required this.isHollow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isHollow ? AppTokens.surface : color,
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Displays the price summary.
class _PriceSection extends StatelessWidget {
  final double price;

  const _PriceSection({required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Price summary',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        Text(
          'PKR ${price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTokens.brand,
          ),
        ),
      ],
    );
  }
}

/// Displays driver information.
class _DriverSection extends StatelessWidget {
  final Driver driver;
  final bool isInstant;

  const _DriverSection({required this.driver, required this.isInstant});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Driver Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.brand, width: 2),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  driver.name.isNotEmpty ? driver.name[0].toUpperCase() : 'D',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: AppTokens.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 16, color: AppTokens.warning),
                      const SizedBox(width: 4),
                      Text(
                        driver.rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        const SizedBox(height: AppTokens.space4),
        _DriverBadge(
          icon: Icons.verified_user,
          text: 'Verified Profile',
          color: AppTokens.brand,
        ),
        const SizedBox(height: AppTokens.space2),
        _DriverBadge(
          icon: Icons.event_busy,
          text: 'Rarely cancels rides',
          color: AppTokens.brand, // Using brand as a proxy for teal/success
        ),
        if (isInstant) ...[
          const SizedBox(height: AppTokens.space2),
          _DriverBadge(
            icon: Icons.bolt,
            text: 'Instant Booking',
            color: AppTokens.brand,
          ),
        ],
        const SizedBox(height: AppTokens.space4),
        Container(
          padding: const EdgeInsets.only(left: AppTokens.space3),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppTokens.brand, width: 2)),
          ),
          child: const Text(
            '"I will start from the city center, can pick you up anywhere along the main road."',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _DriverBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _DriverBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppTokens.space3),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

/// The fixed footer with the Booking button.
class _BookingFooter extends StatelessWidget {
  final Ride ride;

  const _BookingFooter({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space4),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Consumer<BookingProvider>(
        builder: (context, bookingProvider, _) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.brand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppTokens.space4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                ),
                elevation: 4,
              ),
              onPressed: () {
                bookingProvider.startBooking(
                  ride: ride,
                );

                context.pushNamed('booking-summary');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt),
                  SizedBox(width: 8),
                  Text(
                    'Book',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
