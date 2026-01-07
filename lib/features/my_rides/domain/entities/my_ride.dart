import 'my_ride_role.dart';
import 'my_ride_status.dart';
import 'ride_passenger.dart';
import 'ride_user.dart';

class MyRide {
  final String id;

  // Route
  final String fromCity;
  final String fromAddress;
  final String toCity;
  final String toAddress;

  // Timing
  final DateTime departureTime;
  final Duration estimatedDuration;

  // Pricing + seats
  final double pricePerSeat;
  final int seatsTotal;
  final int seatsAvailable;

  // Context
  final MyRideRole role;
  final MyRideStatus status;
  final bool isArchived;

  // People / vehicle
  final RideUser driver;
  final List<RidePassenger> passengers; // meaningful when role == driver
  final String? vehicleName;

  const MyRide({
    required this.id,
    required this.fromCity,
    required this.fromAddress,
    required this.toCity,
    required this.toAddress,
    required this.departureTime,
    required this.estimatedDuration,
    required this.pricePerSeat,
    required this.seatsTotal,
    required this.seatsAvailable,
    required this.role,
    required this.status,
    required this.isArchived,
    required this.driver,
    this.passengers = const [],
    this.vehicleName,
  });

  int get seatsBooked => (seatsTotal - seatsAvailable).clamp(0, seatsTotal);
}
