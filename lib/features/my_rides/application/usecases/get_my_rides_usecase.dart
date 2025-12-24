import '../../domain/entities/my_ride.dart';
import '../../domain/repositories/my_rides_repository.dart';

class GetMyRidesUseCase {
  final MyRidesRepository _repo;
  const GetMyRidesUseCase(this._repo);

  Future<List<MyRide>> call() => _repo.getMyRides();
}
