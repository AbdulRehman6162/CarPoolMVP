import '../../domain/entities/my_ride.dart';
import '../../domain/repositories/my_rides_repository.dart';

class GetArchivedRidesUseCase {
  final MyRidesRepository _repo;
  const GetArchivedRidesUseCase(this._repo);

  Future<List<MyRide>> call() => _repo.getArchivedRides();
}
