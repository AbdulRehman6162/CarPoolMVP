import '../entities/location_selection.dart';
import '../entities/route_option.dart';

abstract class RouteRepository {
  Future<List<RouteOption>> getRouteOptions({
    required LocationSelection pickup,
    required LocationSelection dropoff,
    int max = 3,
  });
}
