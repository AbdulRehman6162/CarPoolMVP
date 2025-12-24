import '../../domain/entities/my_ride.dart';
import '../../domain/repositories/my_rides_repository.dart';

class GetMyRideDetailsUseCase {
  final MyRidesRepository _repo;
  const GetMyRideDetailsUseCase(this._repo);

  Future<MyRide> call(String rideId) => _repo.getRideDetails(rideId);
}
