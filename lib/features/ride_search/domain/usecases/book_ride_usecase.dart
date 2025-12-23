import '../entities/booking_result.dart';
import '../entities/booking_request.dart';
import '../repositories/ride_repository.dart';

class BookRideUseCase {
  final RideRepository repository;
  BookRideUseCase(this.repository);

  Future<BookingResult> call(BookingRequest request)  {
    return repository.submitBooking(request);
  }

}

