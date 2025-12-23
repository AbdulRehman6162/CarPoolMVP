import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_step_scaffold.dart';

class ReturnRideDatePage extends StatelessWidget {
  const ReturnRideDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Return ride date',
      primaryCta: 'Continue',
      onPrimary: () => context.go('/post-ride/return/time'),
      child: const Center(child: Text('Return ride date UI (reuse date picker if desired).')),
    );
  }
}
