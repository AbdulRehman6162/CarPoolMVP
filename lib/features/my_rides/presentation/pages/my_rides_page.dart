import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/my_ride.dart';
import '../providers/my_rides_provider.dart';
import '../widgets/my_ride_card.dart';

class MyRidesPage extends StatefulWidget {
  const MyRidesPage({super.key});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isLoggedIn) {
        context.read<MyRidesProvider>().loadMyRides();
      }
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your rides')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please login to view your rides.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/login?from=/my-rides'),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your rides'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'All rides'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<MyRidesProvider>(
        builder: (context, prov, _) {
          if (prov.loading && prov.rides.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null && prov.rides.isEmpty) {
            return _ErrorState(
              message: prov.error!,
              onRetry: prov.loadMyRides,
            );
          }

          return Column(
            children: [
              ListTile(
                title: const Text('Archived rides'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/my-rides/archived'),
              ),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    _RideList(rides: prov.filtered(MyRidesTab.all)),
                    _RideList(rides: prov.filtered(MyRidesTab.upcoming)),
                    _RideList(rides: prov.filtered(MyRidesTab.completed)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RideList extends StatelessWidget {
  final List<MyRide> rides;
  const _RideList({required this.rides});

  @override
  Widget build(BuildContext context) {
    if (rides.isEmpty) {
      return const Center(child: Text('No rides found.'));
    }
    return RefreshIndicator(
      onRefresh: () => context.read<MyRidesProvider>().loadMyRides(),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: rides.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final ride = rides[index];
          return MyRideCard(
            ride: ride,
            onTap: () => context.go('/my-rides/details', extra: ride),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => onRetry(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
