import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PostRideDatePage extends StatelessWidget {
  const PostRideDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Select date',
      primaryCta: 'Continue',
      onPrimary: () => context.go('/post-ride/time'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pick departure date'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                firstDate: now,
                lastDate: now.add(const Duration(days: 90)),
                initialDate: now,
              );
              if (picked != null) {
                await context.read<PostRideDraftProvider>().setDepartureDate(picked);
              }
            },
            child: const Text('Open date picker'),
          ),
          const SizedBox(height: 12),
          Consumer<PostRideDraftProvider>(
            builder: (_, prov, __) {
              final d = prov.draft?.departureDate;
              return Text(d == null ? 'No date selected' : 'Selected: ${d.toIso8601String().split("T").first}');
            },
          ),
        ],
      ),
    );
  }
}
