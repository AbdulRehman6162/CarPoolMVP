import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getMyVehicles();
  Future<void> addVehicle(Vehicle vehicle);
}
