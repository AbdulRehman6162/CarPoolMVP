import '../../domain/entities/ride_draft.dart';
import '../../domain/repositories/ride_publish_repository.dart';

class RidePublishRepositoryMock implements RidePublishRepository {
  @override
  Future<String> publishRide(RideDraft draft) async {
    // Replace with API call + idempotency key later.
    return 'ride_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> publishReturnRide(RideDraft returnDraft) async {
    return 'ride_return_${DateTime.now().millisecondsSinceEpoch}';
  }
}
