import 'package:meta/meta.dart';

@immutable
class RouteOption {
  final String id;
  final String label;
  final double distanceKm;
  final int durationMin;

  const RouteOption({
    required this.id,
    required this.label,
    required this.distanceKm,
    required this.durationMin,
  });
}
