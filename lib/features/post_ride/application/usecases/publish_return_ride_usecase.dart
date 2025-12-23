import '../../domain/entities/ride_draft.dart';
import '../../domain/repositories/ride_publish_repository.dart';

class PublishReturnRideUseCase {
  final RidePublishRepository _repo;
  PublishReturnRideUseCase(this._repo);

  Future<String> call(RideDraft returnDraft) => _repo.publishReturnRide(returnDraft);
}
