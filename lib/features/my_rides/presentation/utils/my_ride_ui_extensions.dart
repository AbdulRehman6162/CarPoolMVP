import '../../domain/entities/my_ride.dart';

extension MyRideUiX on MyRide {
  bool get isUpcoming => !isArchived && departureTime.isAfter(DateTime.now());
  bool get isCompleted => !isArchived && departureTime.isBefore(DateTime.now());

  String get formattedDuration {
    final h = estimatedDuration.inHours;
    final m = estimatedDuration.inMinutes.remainder(60);
    if (h <= 0) return '${m}m';
    return '${h}h ${m}m';
  }
}

