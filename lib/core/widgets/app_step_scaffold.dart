import 'package:flutter/material.dart';
import 'app_button.dart';

class AppStepScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final String? primaryCta;
  final VoidCallback? onPrimary;
  final String? secondaryCta;
  final VoidCallback? onSecondary;
  final bool loading;

  const AppStepScaffold({
    super.key,
    required this.title,
    required this.child,
    this.primaryCta,
    this.onPrimary,
    this.secondaryCta,
    this.onSecondary,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: child),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (secondaryCta != null)
                    Expanded(child: AppButton.secondary(secondaryCta!, onPressed: onSecondary)),
                  if (secondaryCta != null && primaryCta != null) const SizedBox(width: 12),
                  if (primaryCta != null)
                    Expanded(child: AppButton.primary(primaryCta!, onPressed: onPrimary, loading: loading)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
