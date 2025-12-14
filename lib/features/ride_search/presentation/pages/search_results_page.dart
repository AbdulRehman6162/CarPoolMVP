import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/tokens.dart';
import '../../domain/entities/ride.dart';
import '../providers/search_providers.dart';

class SearchResultsPage extends ConsumerWidget {
  final String from;
  final String to;
  final String date;

  const SearchResultsPage({
    super.key,
    required this.from,
    required this.to,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the results provider (you need to update your provider to accept arguments)
    // For now, let's assume a provider that fetches based on state
    final ridesAsync = ref.watch(searchResultsProvider(
      SearchArgs(from: from, to: to, date: DateTime.parse(date),)
    ));

    return Scaffold(
      backgroundColor: AppTokens.surfaceVariant,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppTokens.text),
        title: Column(
          children: [
            Text('$from → $to', style: TextStyle(color: AppTokens.text, fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Today, 1 passenger', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.filter_list, color: AppTokens.brand), onPressed: () {}),
        ],
      ),
      body: ridesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (rides) => ListView.builder(
          padding: EdgeInsets.all(AppTokens.space4),
          itemCount: rides.length,
          itemBuilder: (context, index) {
            final ride = rides[index];
            return _buildRideCard(context, ride);
          },
        ),
      ),
    );
  }

  Widget _buildRideCard(BuildContext context, Ride ride) {
    return GestureDetector(
      onTap: () => context.push('/ride-details', extra: ride),
      child: Container(
        margin: EdgeInsets.only(bottom: AppTokens.space4),
        padding: EdgeInsets.all(AppTokens.space4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          boxShadow: AppTokens.cardShadow,
        ),
        child: Column(
          children: [
            // Time & Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('HH:mm').format(ride.departureTime), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 4),
                    Text(ride.duration, style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 4),
                    Text(DateFormat('HH:mm').format(ride.arrivalTime), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                // Visual Timeline (simplified)
                Expanded(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(border: Border(left: BorderSide(color: AppTokens.outline, width: 2))),
                  ),
                ),
                Text('PKR ${ride.price}', style: TextStyle(color: AppTokens.brand, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            Divider(height: 24),
            // Driver Row
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(ride.driverImage), radius: 16),
                SizedBox(width: 8),
                Text(ride.driverName, style: TextStyle(fontWeight: FontWeight.w600)),
                Spacer(),
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text(ride.driverRating.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}