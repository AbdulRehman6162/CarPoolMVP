import '../entities/ride.dart';
import '../entities/search_filters.dart';
import '../repositories/ride_repository.dart';

class SearchRidesUseCase {
  final RideRepository repository;

  SearchRidesUseCase(this.repository);

  Future<List<Ride>> call(SearchFilters filters) {
    return repository.searchRides(filters);
  }
}
