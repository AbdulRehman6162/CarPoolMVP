import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_step_scaffold.dart';

class ReturnRidePromptPage extends StatelessWidget {
  final String? rideId;
  const ReturnRidePromptPage({super.key, this.rideId});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Ride published',
      primaryCta: 'Post return ride',
      secondaryCta: 'Done',
      onSecondary: () => context.go('/'),
      onPrimary: () => context.go('/post-ride/return/date'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your ride has been published${rideId == null ? '' : ' (ID: $rideId)'}'),
          const SizedBox(height: 12),
          const Text('Would you like to post a return ride as well? (Optional)'),
        ],
      ),
    );
  }
}
