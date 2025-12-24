import '../../domain/entities/ride_passenger.dart';
import 'ride_user_model.dart';

class RidePassengerModel {
  final RideUserModel user;
  final int seatsBooked;
  final String? note;

  const RidePassengerModel({
    required this.user,
    required this.seatsBooked,
    this.note,
  });

  factory RidePassengerModel.fromJson(Map<String, dynamic> json) => RidePassengerModel(
        user: RideUserModel.fromJson(json['user'] as Map<String, dynamic>),
        seatsBooked: json['seatsBooked'] as int? ?? 1,
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'seatsBooked': seatsBooked,
        'note': note,
      };

  RidePassenger toEntity() => RidePassenger(
        user: user.toEntity(),
        seatsBooked: seatsBooked,
        note: note,
      );
}
