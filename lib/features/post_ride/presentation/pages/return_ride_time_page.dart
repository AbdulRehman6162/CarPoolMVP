import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_step_scaffold.dart';

class ReturnRideTimePage extends StatelessWidget {
  const ReturnRideTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Return ride time',
      primaryCta: 'Continue',
      onPrimary: () => context.go('/post-ride/return/seats'),
      child: const Center(child: Text('Return ride time UI (reuse time picker if desired).')),
    );
  }
}
