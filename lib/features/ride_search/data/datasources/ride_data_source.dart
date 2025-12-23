import '../../domain/entities/booking_request.dart';
import '../../domain/entities/search_filters.dart';
import '../models/booking_result_model.dart';
import '../models/ride_model.dart';

/// The contract (interface) for any data source that provides Ride data.
/// This could be a Remote API, a Local Database, or a Mock for testing.
abstract class RideDataSource {
  Future<List<RideModel>> fetchRides(SearchFilters filters);

  Future<RideModel> fetchRideDetails(String rideId);

  Future<BookingResultModel> sendBooking(BookingRequest request);
}