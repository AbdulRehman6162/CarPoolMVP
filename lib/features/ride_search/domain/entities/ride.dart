class Ride {
  final String id;
  final String driverName;
  final String driverImage;
  final double driverRating;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int price;
  final int seatsAvailable;

  const Ride({
    required this.id,
    required this.driverName,
    required this.driverImage,
    required this.driverRating,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.seatsAvailable,
  });

  // Helper to calculate duration
  String get duration {
    final diff = arrivalTime.difference(departureTime);
    return '${diff.inHours}h ${diff.inMinutes.remainder(60)}m';
  }
}