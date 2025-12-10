
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/search/pages/search_page.dart';
import '../features/booking/pages/booking_requests_page.dart';
import '../features/booking/pages/booking_confirmed_page.dart';
import '../features/publish/pages/publish_ride_page.dart';
import '../features/chat/pages/chat_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/booking-requests',
      name: 'bookingRequests',
      builder: (context, state) => const BookingRequestsPage(),
    ),
    GoRoute(
      path: '/booking-confirmed',
      name: 'bookingConfirmed',
      builder: (context, state) => const BookingConfirmedPage(),
    ),
    GoRoute(
      path: '/publish',
      name: 'publishRide',
      builder: (context, state) => const PublishRidePage(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        final name = state.uri.queryParameters['name'] ?? 'Ali Khan';
        final online = state.uri.queryParameters['online'] ?? 'true';
        final avatar = state.uri.queryParameters['avatar'];
        return ChatPage(name: name, isOnline: online == 'true', avatarUrl: avatar);
      },
    ),
  ],
);
