import '../../domain/entities/booking_request.dart';
import '../../domain/entities/booking_result.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/ride_repository.dart';
import '../../data/datasources/ride_data_source.dart';

class RideRepositoryImpl implements RideRepository {
  final RideDataSource remote;

  RideRepositoryImpl(this.remote);

  @override
  Future<List<Ride>> searchRides(SearchFilters filters) async {
    final models = await remote.fetchRides(filters);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Ride> getRideDetails(String rideId) async {
    final model = await remote.fetchRideDetails(rideId);
    return model.toEntity();
  }

  @override
  Future<BookingResult> submitBooking(BookingRequest request) async {
    final resultModel = await remote.sendBooking(request);
    return resultModel;
  }
}
