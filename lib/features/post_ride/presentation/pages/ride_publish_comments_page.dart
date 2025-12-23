import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_step_scaffold.dart';
import '../../application/usecases/ensure_publish_eligibility_usecase.dart';
import '../providers/post_ride_draft_provider.dart';
import '../providers/post_ride_publish_provider.dart';

class RidePublishCommentsPage extends StatefulWidget {
  const RidePublishCommentsPage({super.key});

  @override
  State<RidePublishCommentsPage> createState() => _RidePublishCommentsPageState();
}

class _RidePublishCommentsPageState extends State<RidePublishCommentsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PostRideDraftProvider, PostRidePublishProvider>(
      builder: (context, draftProv, publishProv, _) {
        return AppStepScaffold(
          title: 'Publish comments',
          primaryCta: 'Publish ride',
          loading: publishProv.loading,
          onPrimary: () async {
            await draftProv.setComments(_controller.text.trim());

            final ensureEligibility = context.read<EnsurePublishEligibilityUseCase>();
            final res = await ensureEligibility(
              redirectFrom: '/post-ride/publish-comments',
              selectedVehicleId: draftProv.draft?.vehicleId,
            );

            if (!mounted) return;

            if (res is NeedsLogin) {
              context.go('/login?from=${res.redirectFrom}');
              return;
            }
            if (res is NeedsVehicle) {
              context.go('/post-ride/add-vehicle?from=${res.redirectFrom}');
              return;
            }
            if (res is NeedsVehicleSelection) {
              context.go('/post-ride/vehicle');
              return;
            }
            if (res is Eligible) {
              // Auto-select single vehicle if needed.
              if (draftProv.draft?.vehicleId == null) {
                await draftProv.setVehicleId(res.selectedVehicleId);
              }
            }

            if (!mounted) return;

            final draft = draftProv.draft;
            if (draft == null) return;

            final rideId = await publishProv.publish(draft);

            if (!mounted) return;

            if (rideId == null) {
              final msg = publishProv.errorMessage ?? 'Failed to publish ride.';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              return;
            }

            context.go('/post-ride/return/prompt?rideId=$rideId');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add any notes for passengers (optional)'),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'e.g., Please be on time. No smoking.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text('You can save draft without login. Publishing requires login + vehicle.'),
            ],
          ),
        );
      },
    );
  }
}
