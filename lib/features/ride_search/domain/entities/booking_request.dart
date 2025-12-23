import 'ride.dart';
import 'passenger.dart';

class BookingRequest {
  final Ride ride;
  final Passenger passenger;
  final int seats;
  final String comment;
  final DateTime requestedAt;

  const BookingRequest({
    required this.ride,
    required this.passenger,
    required this.seats,
    required this.comment,
    required this.requestedAt,
  });
}
