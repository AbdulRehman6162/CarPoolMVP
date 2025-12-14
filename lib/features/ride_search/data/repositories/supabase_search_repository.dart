import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/ride.dart';

class SupabaseSearchRepository implements SearchRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Ride>> searchRides(String from, String to, DateTime date) async {
    // This query assumes you have a table names 'rides' in Supabase
    final response = await _client
        .from('rides')
        .select()
        .eq('origin', from)
        .eq('destination', to)
        .gte('departure_time', date.toIso8601String());
    // Convert JSON to domain Entity
    return (response as List).map((json) => Ride(
      id: json['id'],
      driverName: json['driverName'], // Adjust keys to match your db
      driverImage: json['driverImage']??'',
      driverRating: 4.8, // Example default rating
      from: json['origin'],
      to: json['destination'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      price: json['price'],
      seatsAvailable: json['seats_available']
    )).toList();
  }

  @override
  Future<List<Location>> searchLocations(String query) async {
    // Real Implementation to fetch location and cities
    return [];
  }

  @override
  Future<List<Location>> getRecentLocations() async {
    // TODO: Implement logic to fetch recent locations from Supabase or local storage
    // For now, returning an empty list resolves the error.
    return [];
  }
}
