import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_step_scaffold.dart';
import '../../../vehicle/presentation/providers/vehicle_provider.dart';
import '../providers/post_ride_draft_provider.dart';

class VehicleSelectPage extends StatelessWidget {
  const VehicleSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<VehicleProvider, PostRideDraftProvider>(
      builder: (context, vehicleProv, draftProv, _) {
        final vehicles = vehicleProv.vehicles;

        return AppStepScaffold(
          title: 'Select vehicle',
          primaryCta: 'Continue',
          onPrimary: () => context.go('/post-ride/publish-comments'),
          child: vehicles.isEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('No vehicles found.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/post-ride/add-vehicle?from=/post-ride/vehicle'),
                child: const Text('Add vehicle'),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Which car are you travelling with?'),
              const SizedBox(height: 12),
              ...vehicles.map((v) {
                final selected = draftProv.draft?.vehicleId == v.id;
                return ListTile(
                  title: Text(v.displayName),
                  subtitle: Text('${v.plateMasked} · ${v.seats} seats'),
                  trailing: selected ? const Icon(Icons.check_circle) : null,
                  onTap: () => draftProv.setVehicleId(v.id),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
