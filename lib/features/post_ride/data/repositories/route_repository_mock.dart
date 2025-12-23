import '../../domain/entities/location_selection.dart';
import '../../domain/entities/route_option.dart';
import '../../domain/repositories/route_repository.dart';

class RouteRepositoryMock implements RouteRepository {
  @override
  Future<List<RouteOption>> getRouteOptions({
    required LocationSelection pickup,
    required LocationSelection dropoff,
    int max = 3,
  }) async {
    // Mock “backend routes”. Replace with real API later.
    final all = <RouteOption>[
      const RouteOption(id: 'r1', label: 'Fastest route', distanceKm: 18.6, durationMin: 35),
      const RouteOption(id: 'r2', label: 'Shorter route', distanceKm: 15.2, durationMin: 42),
      const RouteOption(id: 'r3', label: 'Avoid tolls', distanceKm: 20.1, durationMin: 45),
    ];
    return all.take(max).toList();
  }
}
