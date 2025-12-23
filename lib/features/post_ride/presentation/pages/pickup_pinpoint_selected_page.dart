import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PickupPinpointSelectedPage extends StatelessWidget {
  const PickupPinpointSelectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Pickup pin selected',
      primaryCta: 'Continue',
      onPrimary: () async {
        // Replace with actual map pin coordinates.
        await context.read<PostRideDraftProvider>().setPickupPin(31.5204, 74.3587);
        context.go('/post-ride/dropoff');
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pickup pin saved.'),
          SizedBox(height: 12),
          Expanded(child: Center(child: Text('[Pin selected preview]'))),
        ],
      ),
    );
  }
}
