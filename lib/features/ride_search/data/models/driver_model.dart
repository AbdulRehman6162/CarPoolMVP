import '../../domain/entities/driver.dart';

class DriverModel {
  final String id;
  final String name;
  final String licenseNumber;
  final double rating;

  const DriverModel({
    required this.id,
    required this.name,
    required this.licenseNumber,
    required this.rating,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      licenseNumber: json['licenseNumber'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'licenseNumber': licenseNumber,
      'rating': rating,
    };
  }

  Driver toEntity() => Driver(
        id: id,
        name: name,
        licenseNumber: licenseNumber,
        rating: rating,
      );

  static DriverModel fromEntity(Driver d) => DriverModel(
        id: d.id,
        name: d.name,
        licenseNumber: d.licenseNumber,
        rating: d.rating,
      );
}
