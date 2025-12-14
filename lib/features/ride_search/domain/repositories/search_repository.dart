import '../entities/ride.dart';
import '../entities/location.dart';

abstract class SearchRepository {
  // This was missing, causing the error in search_providers.dart
  Future<List<Ride>> searchRides(String from, String to, DateTime date);

  // This is needed for the Location Picker
  Future<List<Location>> searchLocations(String query);
}