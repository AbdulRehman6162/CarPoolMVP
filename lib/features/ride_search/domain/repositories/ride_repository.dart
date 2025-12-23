import '../entities/ride.dart';
import '../entities/search_filters.dart';
import '../entities/booking_request.dart';
import '../entities/booking_result.dart';

abstract class RideRepository {
  Future<List<Ride>> searchRides(SearchFilters filters);

  Future<Ride> getRideDetails(String rideId);

  Future<BookingResult> submitBooking(BookingRequest request);
}
