import 'package:flutter/foundation.dart';

import '../../domain/entities/ride.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/usecases/search_rides_usecase.dart';

class RideSearchProvider extends ChangeNotifier {
  final SearchRidesUseCase searchRidesUseCase;

  RideSearchProvider(this.searchRidesUseCase)
      : _filters = SearchFilters.initial();

  SearchFilters _filters;
  List<Ride> _rides = [];
  bool _isLoading = false;
  String? _errorMessage;

  SearchFilters get filters => _filters;
  List<Ride> get rides => _rides;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateFromCity(String value) {
    _filters = _filters.copyWith(fromCity: value);
    notifyListeners();
  }

  void updateToCity(String value) {
    _filters = _filters.copyWith(toCity: value);
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _filters = _filters.copyWith(date: date);
    notifyListeners();
  }

  void updateSeats(int seats) {
    _filters = _filters.copyWith(seats: seats);
    notifyListeners();
  }

  Future<void> searchRides() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rides = await searchRidesUseCase(_filters);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
