import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/tokens.dart';
import '../../domain/entities/ride.dart';
import '../provider/ride_search_provider.dart';
import 'ride_details_page.dart';

class RideResultsPage extends StatelessWidget {
  const RideResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSearchProvider>(
      builder: (context, provider, _) {
        final rides = provider.rides;
        final filters = provider.filters;

        return Scaffold(
          backgroundColor: AppTokens.surfaceVariant,
          appBar: AppBar(
            backgroundColor: AppTokens.surface,
            elevation: 1,
            // subtle shadow like shadow-md
            iconTheme: const IconThemeData(color: Colors.grey),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  '${filters.fromCity.isEmpty ? "Lahore" : filters.fromCity} → ${filters.toCity.isEmpty ? "Islamabad" : filters.toCity}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTokens.text,
                      ),
                ),
                Text(
                  'Today, ${filters.seats} passenger${filters.seats > 1 ? "s" : ""}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppTokens.brand),
                onPressed: () {
                  // TODO: Implement filter functionality
                },
              ),
            ],
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(AppTokens.space4),
            itemCount: rides.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppTokens.space4),
            itemBuilder: (context, index) {
              final ride = rides[index];
              return _RideResultCard(ride: ride);
            },
          ),
        );
      },
    );
  }
}

/// A specialized Card component for displaying a Ride result.
/// Adheres to SRP: It only cares about rendering a single ride card.
class _RideResultCard extends StatelessWidget {
  final Ride ride;

  const _RideResultCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    // Calculating duration simply for display purposes (dummy logic for now as Ride doesn't strictly have duration)
    // In a real app, this would be computed in the Domain layer or formatted in a ViewModel.
    final arrivalTime = ride.departureTime.add(const Duration(hours: 4));

    return InkWell(
      onTap: () {
        context.goNamed('ride-details', extra: ride);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          boxShadow: AppTokens.cardShadow,
        ),
        padding: const EdgeInsets.all(AppTokens.space4),
        child: Column(
          children: [
            // Time & Route Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Times Column
                Column(
                  children: [
                    Text(
                      _formatTime(ride.departureTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTokens.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '4h 00m', // Placeholder duration
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(arrivalTime),
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppTokens.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppTokens.space4),

                // Visual Timeline
                Expanded(
                  child: SizedBox(
                    height: 70, // Height to match the text column roughly
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _Dot(color: AppTokens.brand, isHollow: true),
                        Expanded(
                          child: Container(
                            width: 2,
                            color: AppTokens.outline.withOpacity(0.5),
                          ),
                        ),
                        const _Dot(color: AppTokens.brand, isHollow: false),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.space4),

                // Locations & Price
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Locations
                      SizedBox(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ride.fromCity,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTokens.text,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ride.toCity,
                              style: const TextStyle(
                                color: AppTokens.text,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Text(
                  'PKR ${ride.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTokens.brand,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTokens.space4),
            const Divider(height: 1, color: AppTokens.outline),
            const SizedBox(height: AppTokens.space4),

            // Driver Info Row
            Row(
              children: [
                // Avatar (Placeholder for now, or use AppAvatar if available)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    ride.driver.name.isNotEmpty
                        ? ride.driver.name[0].toUpperCase()
                        : 'D',
                    style: const TextStyle(color: AppTokens.text),
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.driver.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTokens.text,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: AppTokens.warning),
                          const SizedBox(width: 4),
                          Text(
                            ride.driver.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

/// Simple visual dot component for the timeline.
class _Dot extends StatelessWidget {
  final Color color;
  final bool isHollow;

  const _Dot({required this.color, required this.isHollow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isHollow ? Colors.white : color,
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }
}
