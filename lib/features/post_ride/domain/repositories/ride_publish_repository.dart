import '../entities/ride_draft.dart';

abstract class RidePublishRepository {
  /// Publishes a ride on backend and returns published rideId.
  Future<String> publishRide(RideDraft draft);

  /// Optional: publish a return ride.
  Future<String> publishReturnRide(RideDraft returnDraft);
}
