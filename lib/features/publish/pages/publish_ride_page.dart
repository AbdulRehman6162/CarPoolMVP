
import 'package:flutter/material.dart';
import '../../../core/design_system/tokens.dart';
import '../../../core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';

class PublishRidePage extends StatefulWidget {
  const PublishRidePage({super.key});

  @override
  State<PublishRidePage> createState() => _PublishRidePageState();
}

class _PublishRidePageState extends State<PublishRidePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ready to publish\nyour ride?', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          const Text('Would you like to add a comment for your passengers?'),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Flexible about where and when to meet? Not taking the motorway? Got limited space? Keep passengers in the loop.',
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: AppButton.primary('Publish ride', onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publishing...')));
              await Future.delayed(const Duration(milliseconds: 600));
              if (context.mounted) context.push('/booking-confirmed');
            }),
          ),
        ]),
      ),
    );
  }
}
