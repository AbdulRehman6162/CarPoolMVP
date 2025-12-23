import '../../domain/entities/location_selection.dart';
import '../../domain/entities/route_option.dart';
import '../../domain/repositories/route_repository.dart';

class GetRouteOptionsUseCase {
  final RouteRepository _repo;
  GetRouteOptionsUseCase(this._repo);

  Future<List<RouteOption>> call({
    required LocationSelection pickup,
    required LocationSelection dropoff,
    int max = 3,
  }) {
    return _repo.getRouteOptions(pickup: pickup, dropoff: dropoff, max: max);
  }
}
