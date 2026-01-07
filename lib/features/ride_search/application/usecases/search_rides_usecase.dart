import '../../domain/entities/ride.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/ride_repository.dart';

class SearchRidesUseCase {
  final RideRepository repository;

  SearchRidesUseCase(this.repository);

  Future<List<Ride>> call(SearchFilters filters) {
    return repository.searchRides(filters);
  }
}
