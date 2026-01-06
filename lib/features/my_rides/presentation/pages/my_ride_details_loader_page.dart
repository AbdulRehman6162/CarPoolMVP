import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/my_rides_provider.dart';
import 'my_ride_details_page.dart';

class MyRideDetailsLoaderPage extends StatefulWidget {
  final String rideId;
  final bool archivedMode;

  const MyRideDetailsLoaderPage({
    super.key,
    required this.rideId,
    this.archivedMode = false,
  });

  @override
  State<MyRideDetailsLoaderPage> createState() => _MyRideDetailsLoaderPageState();
}

class _MyRideDetailsLoaderPageState extends State<MyRideDetailsLoaderPage> {
  @override
  void initState() {
    super.initState();
    // Load details after first frame so Provider is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyRidesProvider>().loadDetails(widget.rideId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRidesProvider>(
      builder: (context, prov, _) {
        if (prov.detailsLoading && prov.currentRideDetails == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (prov.detailsError != null && prov.currentRideDetails == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ride details')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      prov.detailsError!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => prov.loadDetails(widget.rideId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final ride = prov.currentRideDetails;
        if (ride == null) {
          return const Scaffold(
            body: Center(child: Text('Ride not found.')),
          );
        }

        return MyRideDetailsPage(
          ride: ride,
          archivedMode: widget.archivedMode,
        );
      },
    );
  }
}
