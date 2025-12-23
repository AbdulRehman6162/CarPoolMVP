import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PostRideSeatsPage extends StatefulWidget {
  const PostRideSeatsPage({super.key});

  @override
  State<PostRideSeatsPage> createState() => _PostRideSeatsPageState();
}

class _PostRideSeatsPageState extends State<PostRideSeatsPage> {
  int _seats = 1;

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Seats offered',
      primaryCta: 'Continue',
      onPrimary: () async {
        await context.read<PostRideDraftProvider>().setSeatsOffered(_seats);

        if (_seats >= 6) {
          if (context.mounted) {
            await showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Seats exceeded'),
                content: const Text('Offering 6 or more seats may require a larger vehicle. Please ensure compliance.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                ],
              ),
            );
          }
        }

        if (context.mounted) context.go('/post-ride/instant-booking');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How many seats are you offering?'),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: _seats > 1 ? () => setState(() => _seats--) : null,
                icon: const Icon(Icons.remove),
              ),
              Text('$_seats', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                onPressed: _seats < 7 ? () => setState(() => _seats++) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Note: If you offer 6–7 seats, we may show a caution message.'),
        ],
      ),
    );
  }
}
