import 'package:flutter/foundation.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _repo;
  VehicleProvider(this._repo);

  List<Vehicle> _vehicles = const [];
  bool _loading = false;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _loading;
  bool get hasVehicles => _vehicles.isNotEmpty;

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    try {
      _vehicles = await _repo.getMyVehicles();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle({
    required String make,
    required String model,
    required String plateMasked,
    required int seats,
  }) async {
    final v = Vehicle(
      id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
      make: make,
      model: model,
      plateMasked: plateMasked,
      seats: seats,
    );
    await _repo.addVehicle(v);
    await refresh();
  }
}
