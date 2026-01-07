import '../../domain/entities/booking_result.dart';
import '../../domain/entities/booking_request.dart';
import '../../domain/repositories/ride_repository.dart';

class BookRideUseCase {
  final RideRepository repository;
  BookRideUseCase(this.repository);

  Future<BookingResult> call(BookingRequest request)  {
    return repository.submitBooking(request);
  }

}

