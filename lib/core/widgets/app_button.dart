
import 'package:flutter/material.dart';
import '../design_system/tokens.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool loading;

  const AppButton.primary(this.label, {super.key, this.onPressed, this.loading = false}) : primary = true;
  const AppButton.secondary(this.label, {super.key, this.onPressed, this.loading = false}) : primary = false;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Text(label);
    if (primary) {
      return ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.brand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusXl)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: child,
      );
    } else {
      return TextButton(onPressed: loading ? null : onPressed, child: child);
    }
  }
}
