import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PostRidePickupAddressPage extends StatefulWidget {
  const PostRidePickupAddressPage({super.key});

  @override
  State<PostRidePickupAddressPage> createState() => _PostRidePickupAddressPageState();
}

class _PostRidePickupAddressPageState extends State<PostRidePickupAddressPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostRideDraftProvider>().ensureDraft();
  }

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Pickup location',
      primaryCta: 'Continue',
      onPrimary: () async {
        final text = _controller.text.trim();
        if (text.isEmpty) return;
        await context.read<PostRideDraftProvider>().setPickupAddress(text);
        // “Backend check” for pin requirement: if no lat/lng -> go to pin flow
        context.go('/post-ride/pickup-pin');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Search pickup address'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'e.g., Gulberg, Lahore',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tip: You can select the area now; we’ll ask for exact pin in the next step.',
          ),
        ],
      ),
    );
  }
}
