import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_step_scaffold.dart';
import '../../application/usecases/ensure_publish_eligibility_usecase.dart';
import '../providers/post_ride_draft_provider.dart';
import '../providers/post_ride_publish_provider.dart';

class ReturnRidePricePage extends StatefulWidget {
  const ReturnRidePricePage({super.key});

  @override
  State<ReturnRidePricePage> createState() => _ReturnRidePricePageState();
}

class _ReturnRidePricePageState extends State<ReturnRidePricePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PostRideDraftProvider, PostRidePublishProvider>(
      builder: (context, draftProv, publishProv, _) {
        return AppStepScaffold(
          title: 'Return ride price',
          primaryCta: 'Publish return ride',
          loading: publishProv.loading,
          onPrimary: () async {
            final ensureEligibility = context.read<EnsurePublishEligibilityUseCase>();
            final res = await ensureEligibility(
              redirectFrom: '/post-ride/return/price',
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
              if (draftProv.draft?.vehicleId == null) {
                await draftProv.setVehicleId(res.selectedVehicleId);
              }
            }

            if (!mounted) return;

            final returnDraft = await draftProv.createReturnDraft();
            final returnRideId = await publishProv.publishReturn(returnDraft);

            if (!mounted) return;
            context.go('/?returnRideId=$returnRideId');
          },
          child: const Center(
            child: Text(
              'Return ride price UI (placeholder).\n'
              'This page now publishes the return ride using the same auth+vehicle gating.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
