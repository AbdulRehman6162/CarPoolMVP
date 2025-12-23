import '../../domain/entities/ride.dart';
import 'driver_model.dart';

class RideModel {
  final String id;
  final String fromCity;
  final String toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int availableSeats;
  final bool isInstantBooking;
  final DriverModel driver;

  const RideModel({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.availableSeats,
    required this.isInstantBooking,
    required this.driver,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      fromCity: json['fromCity'] as String,
      toCity: json['toCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      availableSeats: json['availableSeats'] as int,
      isInstantBooking: json['isInstantBooking'] as bool,
      price: (json['price'] as num).toDouble(),
      driver: DriverModel.fromJson(json['driver'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCity': fromCity,
      'toCity': toCity,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'availableSeats': availableSeats,
      'isInstantBooking': isInstantBooking,
      'price': price,
      'driver': driver.toJson(),
    };
  }

  Ride toEntity() => Ride(
        id: id,
        fromCity: fromCity,
        toCity: toCity,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        price: price,
        availableSeats: availableSeats,
        isInstantBooking: isInstantBooking,
        driver: driver.toEntity(),
      );

  static RideModel fromEntity(Ride r) => RideModel(
        id: r.id,
        fromCity: r.fromCity,
        toCity: r.toCity,
        departureTime: r.departureTime,
        arrivalTime: r.arrivalTime,
        price: r.price,
        availableSeats: r.availableSeats,
        isInstantBooking: r.isInstantBooking,
        driver: DriverModel.fromEntity(r.driver),
      );
}
