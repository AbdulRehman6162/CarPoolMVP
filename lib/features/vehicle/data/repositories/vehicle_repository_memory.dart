import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleRepositoryMemory implements VehicleRepository {
  final List<Vehicle> _vehicles = [];

  @override
  Future<void> addVehicle(Vehicle vehicle) async {
    _vehicles.add(vehicle);
  }

  @override
  Future<List<Vehicle>> getMyVehicles() async => List.unmodifiable(_vehicles);
}
