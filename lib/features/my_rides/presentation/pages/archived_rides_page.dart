import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/my_rides_provider.dart';
import '../widgets/my_ride_card.dart';

class ArchivedRidesPage extends StatefulWidget {
  const ArchivedRidesPage({super.key});

  @override
  State<ArchivedRidesPage> createState() => _ArchivedRidesPageState();
}

class _ArchivedRidesPageState extends State<ArchivedRidesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyRidesProvider>().loadArchived();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archived rides')),
      body: Consumer<MyRidesProvider>(
        builder: (context, prov, _) {
          if (prov.loading && prov.archivedRides.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null && prov.archivedRides.isEmpty) {
            return Center(child: Text(prov.error!));
          }

          final rides = prov.archivedRides;
          if (rides.isEmpty) return const Center(child: Text('No archived rides.'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rides.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final ride = rides[index];
              return MyRideCard(
                ride: ride,
                onTap: () => context.go('/my-rides/archived/details/${ride.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
