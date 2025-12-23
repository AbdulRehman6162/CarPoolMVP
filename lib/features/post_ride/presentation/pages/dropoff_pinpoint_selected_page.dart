import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class DropoffPinpointSelectedPage extends StatelessWidget {
  const DropoffPinpointSelectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Drop-off pin selected',
      primaryCta: 'Continue',
      onPrimary: () async {
        await context.read<PostRideDraftProvider>().setDropoffPin(24.8607, 67.0011);
        // Load routes and go to route selection
        final prov = context.read<PostRideDraftProvider>();
        await prov.loadRouteOptions();
        context.go('/post-ride/route');
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Drop-off pin saved.'),
          SizedBox(height: 12),
          Expanded(child: Center(child: Text('[Pin selected preview]'))),
        ],
      ),
    );
  }
}
