import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class GetRideDetailsUseCase {
  final RideRepository rideRepository;

  GetRideDetailsUseCase(this.rideRepository);

  Future<Ride> call(String rideId) {
    return rideRepository.getRideDetails(rideId);
  }
}
