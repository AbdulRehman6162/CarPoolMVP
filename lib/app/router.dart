
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/ride_search/presentation/pages/location_picker_page.dart';
import '../features/ride_search/presentation/pages/search_results_page.dart';
import '../features/ride_search/presentation/pages/ride_details_page.dart';
import '../features/ride_search/domain/entities/ride.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return SearchResultsPage(
            from: extras['from'],
            to: extras['to'],
            date: extras['date']
        );
      },
    ),
    GoRoute(
      path: '/ride-details',
      builder: (context, state) {
        final ride = state.extra as Ride;
        return RideDetailsPage(ride: ride);
      },
    ),
    GoRoute(
      path: '/location-picker',
      builder: (context, state) {
        final title = state.extra as String? ?? 'Select Location';
        return LocationPickerPage(title: title);
      },
    ),
  ],
);
