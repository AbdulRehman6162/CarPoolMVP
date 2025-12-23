import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class RouteConfirmationPage extends StatelessWidget {
  const RouteConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostRideDraftProvider>(
      builder: (context, prov, _) {
        final routes = prov.routeOptions;

        return AppStepScaffold(
          title: 'Select route',
          primaryCta: 'Continue',
          onPrimary: () => context.go('/post-ride/date'),
          child: prov.loadingRoutes
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Available routes (up to 3)'),
              const SizedBox(height: 12),
              if (routes.isEmpty)
                const Text('No routes found. Please go back and reselect locations.')
              else
                ...routes.map((r) {
                  final selected = prov.draft?.selectedRoute?.id == r.id;
                  return ListTile(
                    title: Text(r.label),
                    subtitle: Text('${r.distanceKm.toStringAsFixed(1)} km · ${r.durationMin} min'),
                    trailing: selected ? const Icon(Icons.check_circle) : null,
                    onTap: () => prov.selectRoute(r),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
