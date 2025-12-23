import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_step_scaffold.dart';

class DropoffPinpointInitialPage extends StatelessWidget {
  const DropoffPinpointInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Confirm drop-off pin',
      primaryCta: 'Set pin',
      onPrimary: () => context.go('/post-ride/dropoff-pin/selected'),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Move map to set the accurate drop-off pin.'),
          SizedBox(height: 12),
          Expanded(child: Center(child: Text('[Map placeholder]'))),
        ],
      ),
    );
  }
}
