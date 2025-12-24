import 'ride_user.dart';

class RidePassenger {
  final RideUser user;
  final int seatsBooked;
  final String? note;

  const RidePassenger({
    required this.user,
    required this.seatsBooked,
    this.note,
  });
}
