import '../../domain/entities/my_ride.dart';
import '../../domain/repositories/my_rides_repository.dart';
import '../datasources/my_rides_remote_data_source.dart';

class MyRidesRepositoryImpl implements MyRidesRepository {
  final MyRidesRemoteDataSource _remote;
  const MyRidesRepositoryImpl(this._remote);

  @override
  Future<List<MyRide>> getMyRides() async {
    final models = await _remote.fetchMyRides();
    final entities = models.map((m) => m.toEntity()).toList();
    entities.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    return entities;
  }

  @override
  Future<List<MyRide>> getArchivedRides() async {
    final models = await _remote.fetchArchivedRides();
    final entities = models.map((m) => m.toEntity()).toList();
    entities.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    return entities;
  }

  @override
  Future<MyRide> getRideDetails(String rideId) async {
    final model = await _remote.fetchRideDetails(rideId);
    return model.toEntity();
  }
}
