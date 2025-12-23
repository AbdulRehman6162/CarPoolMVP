import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_step_scaffold.dart';

class PickupPinpointInitialPage extends StatelessWidget {
  const PickupPinpointInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Confirm pickup pin',
      primaryCta: 'Set pin',
      onPrimary: () => context.go('/post-ride/pickup-pin/selected'),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Move map to set the accurate pickup pin.'),
          SizedBox(height: 12),
          Expanded(
            child: Center(
              child: Text('[Map placeholder]'),
            ),
          ),
        ],
      ),
    );
  }
}
