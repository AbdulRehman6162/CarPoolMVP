import 'dart:async';

import '../../domain/entities/booking_request.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/entities/search_filters.dart';
import '../models/booking_result_model.dart';
import '../models/driver_model.dart';
import '../models/ride_model.dart';

// 1. Import the new interface
import 'ride_data_source.dart';

class RideRemoteDataSource implements RideDataSource {
  // 3. Add @override annotations to ensure you stick to the contract
  @override
  Future<List<RideModel>> fetchRides(SearchFilters filters) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final driver = DriverModel(
      id: 'd1',
      name: 'Ali',
      licenseNumber: 'L-123',
      rating: 4.9,
    );

    final departure = filters.date.add(const Duration(hours: 2));
    final arrival = departure.add(const Duration(hours: 4));

    final ride = RideModel(
      id: 'r1',
      fromCity: filters.fromCity,
      toCity: filters.toCity,
      departureTime: departure,
      arrivalTime: arrival,
      availableSeats: 3,
      isInstantBooking: true,
      price: 2800,
      driver: driver,
    );

    return [ride];
  }

  @override
  Future<RideModel> fetchRideDetails(String rideId) async {
    final filters = SearchFilters(
      fromCity: 'Islamabad',
      toCity: 'Lahore',
      date: DateTime.now(),
      seats: 1,
    );
    final rides = await fetchRides(filters);
    return rides.first;
  }

  @override
  Future<BookingResultModel> sendBooking(BookingRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final status = request.ride.isInstantBooking
        ? BookingStatus.confirmed
        : BookingStatus.pendingDriver;

    final message = request.ride.isInstantBooking
        ? 'Ride confirmed instantly!'
        : 'Your request has been sent to the driver for review.';

    return BookingResultModel(
      status: status,
      message: message,
    );
  }
}
