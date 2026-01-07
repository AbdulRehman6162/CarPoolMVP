import 'package:flutter/foundation.dart';

import '../../domain/entities/booking_request.dart';
import '../../domain/entities/booking_result.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/ride.dart';
import '../../domain/usecases/book_ride_usecase.dart';

class BookingProvider extends ChangeNotifier {
  final BookRideUseCase bookRideUseCase;

  BookingProvider(this.bookRideUseCase);

  Ride? _ride;
  Passenger? _passenger;
  String _comment = '';
  int _seats = 1;

  BookingResult? _result;
  bool _isSubmitting = false;
  String? _errorMessage;

  Ride? get ride => _ride;
  Passenger? get passenger => _passenger;
  String get comment => _comment;
  int get seats => _seats;
  BookingResult? get result => _result;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  void startBooking({
    required Ride ride,
    Passenger? passenger,
    int seats = 1,
  }) {
    _ride = ride;
    _passenger = passenger;
    _seats = seats;
    _comment = '';
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setPassenger(Passenger passenger) {
    _passenger = passenger;
    notifyListeners();
  }

  void updateComment(String value) {
    _comment = value;
    notifyListeners();
  }

  void updateSeats(int value) {
    _seats = value;
    notifyListeners();
  }

  Future<void> submitBooking() async {
    final ride = _ride;
    final passenger = _passenger;
    if (ride == null) {
      _errorMessage = 'Ride not set.';
      notifyListeners();
      return;
    }
    if (passenger == null) {
      _errorMessage = 'Passenger not set.';
      notifyListeners();
      return;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final request = BookingRequest(
      ride: ride,
      passenger: passenger,
      seats: _seats,
      comment: _comment,
      requestedAt: DateTime.now(),
    );

    try {
      _result = await bookRideUseCase(request);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  bool get isConfirmed => _result?.status == BookingStatus.confirmed;
  bool get isPending => _result?.status == BookingStatus.pendingDriver;
}
