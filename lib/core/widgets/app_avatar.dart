
import 'package:flutter/material.dart';
import '../design_system/tokens.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;

  const AppAvatar({super.key, required this.initials, this.imageUrl, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null
          ? Text(initials.characters.first.toUpperCase(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cs.onPrimaryContainer))
          : null,
    );
  }
}
