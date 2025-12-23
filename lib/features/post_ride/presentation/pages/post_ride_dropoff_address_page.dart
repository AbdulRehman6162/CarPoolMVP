import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PostRideDropoffAddressPage extends StatefulWidget {
  const PostRideDropoffAddressPage({super.key});

  @override
  State<PostRideDropoffAddressPage> createState() => _PostRideDropoffAddressPageState();
}

class _PostRideDropoffAddressPageState extends State<PostRideDropoffAddressPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Drop-off location',
      primaryCta: 'Continue',
      onPrimary: () async {
        final text = _controller.text.trim();
        if (text.isEmpty) return;
        await context.read<PostRideDraftProvider>().setDropoffAddress(text);
        context.go('/post-ride/dropoff-pin');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Search drop-off address'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'e.g., DHA Phase 6, Karachi',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text('We’ll ask you to confirm the accurate pin next.'),
        ],
      ),
    );
  }
}
