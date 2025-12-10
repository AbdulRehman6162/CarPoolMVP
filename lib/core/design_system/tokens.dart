
import 'package:flutter/material.dart';

/// Centralized design tokens so styles are consistent everywhere.
class AppTokens {
  // Spacing (8-pt base)
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space6 = 24;

  // Corner radii
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(blurRadius: 12, offset: Offset(0, 2), color: Color(0x14000000)),
  ];

  // Colors
  static const Color brand = Color(0xFF0B57D0);
  static const Color text = Color(0xFF1A1A1A);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF2F4F7);
  static const Color outline = Color(0xFFD0D5DD);
  static const Color success = Color(0xFF12B76A);
  static const Color warning = Color(0xFFF79009);
  static const Color error = Color(0xFFD92D20);
}
