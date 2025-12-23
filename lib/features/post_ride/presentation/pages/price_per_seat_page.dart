import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_step_scaffold.dart';
import '../providers/post_ride_draft_provider.dart';

class PricePerSeatPage extends StatefulWidget {
  const PricePerSeatPage({super.key});

  @override
  State<PricePerSeatPage> createState() => _PricePerSeatPageState();
}

class _PricePerSeatPageState extends State<PricePerSeatPage> {
  final _controller = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Price per seat',
      primaryCta: 'Continue',
      onPrimary: () async {
        final v = int.tryParse(_controller.text.trim()) ?? 0;
        await context.read<PostRideDraftProvider>().setPricePerSeatPkr(v);
        if (context.mounted) context.go('/post-ride/publish-comments');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Set price per seat (PKR)'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: 'PKR ',
              border: OutlineInputBorder(),
              hintText: 'e.g., 500',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Tip: Keep pricing fair for the Pakistani market.'),
        ],
      ),
    );
  }
}
