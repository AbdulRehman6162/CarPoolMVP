import 'package:meta/meta.dart';

@immutable
class Vehicle {
  final String id;
  final String make;
  final String model;
  final String plateMasked;
  final int seats;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.plateMasked,
    required this.seats,
  });

  String get displayName => '$make $model';
}
