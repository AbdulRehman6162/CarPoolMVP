import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PostRideTimePage extends StatelessWidget {
  const PostRideTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Select time',
      primaryCta: 'Continue',
      onPrimary: () => context.go('/post-ride/seats'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pick departure time'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) {
                await context.read<PostRideDraftProvider>().setDepartureTime(hour: t.hour, minute: t.minute);
              }
            },
            child: const Text('Open time picker'),
          ),
          const SizedBox(height: 12),
          Consumer<PostRideDraftProvider>(
            builder: (_, prov, __) {
              final t = prov.draft?.departureTime;
              return Text(t == null ? 'No time selected' : 'Selected: ${t.format24h()}');
            },
          ),
        ],
      ),
    );
  }
}
