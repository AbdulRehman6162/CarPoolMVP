import 'package:flutter/foundation.dart';

import '../../application/usecases/get_archived_rides_usecase.dart';
import '../../application/usecases/get_my_ride_details_usecase.dart';
import '../../application/usecases/get_my_rides_usecase.dart';
import '../../domain/entities/my_ride.dart';
import '../utils/my_ride_ui_extensions.dart';

enum MyRidesTab { all, upcoming, completed }

class MyRidesProvider extends ChangeNotifier {
  final GetMyRidesUseCase _getMyRides;
  final GetArchivedRidesUseCase _getArchived;
  final GetMyRideDetailsUseCase _getDetails;

  MyRidesProvider(this._getMyRides, this._getArchived, this._getDetails);

  bool _loading = false;
  String? _error;

  List<MyRide> _rides = const [];
  List<MyRide> _archived = const [];

  // Details state (kept separate from list state to avoid cross-screen side effects)
  bool _detailsLoading = false;
  String? _detailsError;
  MyRide? _currentRideDetails;

  bool get loading => _loading;
  String? get error => _error;

  List<MyRide> get rides => _rides;
  List<MyRide> get archivedRides => _archived;

  bool get detailsLoading => _detailsLoading;
  String? get detailsError => _detailsError;
  MyRide? get currentRideDetails => _currentRideDetails;

  Future<void> loadMyRides() async {
    _setLoading(true);
    _error = null;
    try {
      _rides = await _getMyRides();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadArchived() async {
    _setLoading(true);
    _error = null;
    try {
      _archived = await _getArchived();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Loads ride details by id (deep-link safe).
  Future<void> loadDetails(String rideId) async {
    _detailsLoading = true;
    _detailsError = null;
    _currentRideDetails = null;
    notifyListeners();

    try {
      _currentRideDetails = await _getDetails(rideId);
    } catch (e) {
      _detailsError = e.toString();
    } finally {
      _detailsLoading = false;
      notifyListeners();
    }
  }

  List<MyRide> filtered(MyRidesTab tab) {
    switch (tab) {
      case MyRidesTab.all:
        return _rides;
      case MyRidesTab.upcoming:
        return _rides.where((r) => r.isUpcoming).toList();
      case MyRidesTab.completed:
        return _rides.where((r) => r.isCompleted).toList();
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
