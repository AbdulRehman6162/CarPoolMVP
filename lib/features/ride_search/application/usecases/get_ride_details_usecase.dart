import '../../domain/entities/ride.dart';
import '../../domain/repositories/ride_repository.dart';

class GetRideDetailsUseCase {
  final RideRepository rideRepository;

  GetRideDetailsUseCase(this.rideRepository);

  Future<Ride> call(String rideId) {
    return rideRepository.getRideDetails(rideId);
  }
}
