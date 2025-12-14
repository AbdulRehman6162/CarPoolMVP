import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/location.dart';
import '../../data/repositories/supabase_search_repository.dart';

// 1. Repository Provider (The connection to data)
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SupabaseSearchRepository();
});

// 2. Search Arguments Class (For passing multiple args to the provider)
class SearchArgs {
  final String from;
  final String to;
  final DateTime date;

  SearchArgs({required this.from, required this.to, required this.date});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SearchArgs &&
              runtimeType == other.runtimeType &&
              from == other.from &&
              to == other.to &&
              date == other.date;

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ date.hashCode;
}

// 3. Search Query Provider (Holds the text user is typing) <--- ADDED THIS
final searchQueryProvider = StateProvider.autoDispose<String>((ref) {
  return ''; // Default is empty string
});

// 4. Search Results Provider (For the Ride List page)
final searchResultsProvider = FutureProvider.family<List<Ride>, SearchArgs>((ref, args) async {
  final repository = ref.watch(searchRepositoryProvider);
  return repository.searchRides(args.from, args.to, args.date);
});

// 5. Location Results Provider (For the Location Picker page)
final locationResultsProvider = FutureProvider.family<List<Location>, String>((ref, query) async {
  // If query is too short, don't ride_search yet to save API calls
  if (query.length < 2) return [];

  final repository = ref.watch(searchRepositoryProvider);
  return repository.searchLocations(query);
});