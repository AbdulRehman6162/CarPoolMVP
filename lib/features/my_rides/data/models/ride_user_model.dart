import '../../domain/entities/ride_user.dart';

class RideUserModel {
  final String id;
  final String name;
  final bool isVerified;

  const RideUserModel({
    required this.id,
    required this.name,
    required this.isVerified,
  });

  factory RideUserModel.fromJson(Map<String, dynamic> json) => RideUserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        isVerified: json['isVerified'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isVerified': isVerified,
      };

  RideUser toEntity() => RideUser(id: id, name: name, isVerified: isVerified);

  static RideUserModel fromEntity(RideUser u) =>
      RideUserModel(id: u.id, name: u.name, isVerified: u.isVerified);
}
