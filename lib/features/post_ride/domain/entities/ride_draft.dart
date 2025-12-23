import 'package:meta/meta.dart';
import 'location_selection.dart';
import 'route_option.dart';

@immutable
class RideDraft {
  final String id;

  final LocationSelection? pickup;
  final LocationSelection? dropoff;

  final RouteOption? selectedRoute;

  final DateTime? departureDate; // date only (we’ll store at midnight)
  final TimeOfDayValue? departureTime; // hours/minutes

  final int seatsOffered;
  final bool instantBooking;

  final int pricePerSeatPkr;

  final String comments;

  final String? vehicleId;

  const RideDraft({
    required this.id,
    this.pickup,
    this.dropoff,
    this.selectedRoute,
    this.departureDate,
    this.departureTime,
    this.seatsOffered = 1,
    this.instantBooking = true,
    this.pricePerSeatPkr = 0,
    this.comments = '',
    this.vehicleId,
  });

  RideDraft copyWith({
    LocationSelection? pickup,
    LocationSelection? dropoff,
    RouteOption? selectedRoute,
    DateTime? departureDate,
    TimeOfDayValue? departureTime,
    int? seatsOffered,
    bool? instantBooking,
    int? pricePerSeatPkr,
    String? comments,
    String? vehicleId,
  }) {
    return RideDraft(
      id: id,
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      seatsOffered: seatsOffered ?? this.seatsOffered,
      instantBooking: instantBooking ?? this.instantBooking,
      pricePerSeatPkr: pricePerSeatPkr ?? this.pricePerSeatPkr,
      comments: comments ?? this.comments,
      vehicleId: vehicleId ?? this.vehicleId,
    );
  }
}

/// Value object to avoid using Flutter’s TimeOfDay in domain (DIP-friendly).
@immutable
class TimeOfDayValue {
  final int hour;
  final int minute;

  const TimeOfDayValue({required this.hour, required this.minute});

  String format24h() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
