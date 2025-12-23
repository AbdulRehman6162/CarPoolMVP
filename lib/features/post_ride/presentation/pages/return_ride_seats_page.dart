import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_step_scaffold.dart';

class ReturnRideSeatsPage extends StatelessWidget {
  const ReturnRideSeatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Return ride seats',
      primaryCta: 'Continue',
      onPrimary: () => context.go('/post-ride/return/price'),
      child: const Center(child: Text('Return ride seats UI (reuse seats step if desired).')),
    );
  }
}
