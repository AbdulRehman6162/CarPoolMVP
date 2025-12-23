import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class EnableInstantBookingPage extends StatefulWidget {
  const EnableInstantBookingPage({super.key});

  @override
  State<EnableInstantBookingPage> createState() => _EnableInstantBookingPageState();
}

class _EnableInstantBookingPageState extends State<EnableInstantBookingPage> {
  bool _instant = true;

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Booking preference',
      primaryCta: 'Continue',
      onPrimary: () async {
        await context.read<PostRideDraftProvider>().setInstantBooking(_instant);
        if (context.mounted) context.go('/post-ride/price');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enable instant booking?'),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _instant,
            onChanged: (v) => setState(() => _instant = v),
            title: Text(_instant ? 'Instant booking enabled' : 'Review each request'),
            subtitle: Text(_instant
                ? 'Passengers can book immediately.'
                : 'You will approve each request manually.'),
          ),
        ],
      ),
    );
  }
}
