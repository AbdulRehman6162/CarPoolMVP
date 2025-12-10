
import 'package:flutter/material.dart';
import '../design_system/tokens.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const AppFilterChip({super.key, required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(0.12) : AppTokens.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppTokens.outline.withOpacity(0.6)),
        ),
        child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: selected ? cs.primary : Theme.of(context).textTheme.bodyMedium?.color,
        )),
      ),
    );
  }
}
