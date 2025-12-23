import 'driver.dart';

class Ride {
  final String id;
  final String fromCity;
  final String toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int availableSeats;
  final bool isInstantBooking;
  final Driver driver;

  const Ride({
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
}
