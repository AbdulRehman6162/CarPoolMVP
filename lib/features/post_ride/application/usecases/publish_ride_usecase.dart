import '../../domain/entities/ride_draft.dart';
import '../../domain/repositories/ride_publish_repository.dart';

class PublishRideUseCase {
  final RidePublishRepository _repo;
  PublishRideUseCase(this._repo);

  Future<String> call(RideDraft draft) => _repo.publishRide(draft);
}
