import 'booking_status.dart';

class BookingResult {
  final BookingStatus status;
  final String message;

  const BookingResult({
    required this.status,
    required this.message,
  });
}
