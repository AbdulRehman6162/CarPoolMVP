import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../vehicle/domain/repositories/vehicle_repository.dart';

/// Result of checking whether the user can publish a ride.
/// Keeps UI thin and consistent across "publish ride" and "publish return ride".
abstract class PublishEligibilityResult {
  const PublishEligibilityResult();
}

class Eligible extends PublishEligibilityResult {
  /// The effective vehicleId that should be used for publishing.
  /// If the user has exactly one vehicle and none was selected, this will be that vehicle id.
  final String selectedVehicleId;
  const Eligible(this.selectedVehicleId);
}

class NeedsLogin extends PublishEligibilityResult {
  /// Where to come back after login.
  final String redirectFrom;
  const NeedsLogin(this.redirectFrom);
}

class NeedsVehicle extends PublishEligibilityResult {
  /// Where to come back after adding a vehicle.
  final String redirectFrom;
  const NeedsVehicle(this.redirectFrom);
}

class NeedsVehicleSelection extends PublishEligibilityResult {
  const NeedsVehicleSelection();
}

class EnsurePublishEligibilityUseCase {
  final AuthRepository _authRepo;
  final VehicleRepository _vehicleRepo;

  const EnsurePublishEligibilityUseCase(this._authRepo, this._vehicleRepo);

  /// [redirectFrom] should be a stable internal route (no host, no scheme).
  Future<PublishEligibilityResult> call({
    required String redirectFrom,
    required String? selectedVehicleId,
  }) async {
    final user = await _authRepo.getCurrentUser();
    if (user == null) return NeedsLogin(redirectFrom);

    final vehicles = await _vehicleRepo.getMyVehicles();
    if (vehicles.isEmpty) return NeedsVehicle(redirectFrom);

    if (vehicles.length >= 2 && selectedVehicleId == null) {
      return const NeedsVehicleSelection();
    }

    // Auto-select if only one vehicle exists.
    final effectiveId = selectedVehicleId ?? vehicles.first.id;
    return Eligible(effectiveId);
  }
}
