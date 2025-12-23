import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/widgets/app_shell_scaffold.dart';

// Auth
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/otp_verification_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

// Ride Search (Home)
import '../features/ride_search/presentation/pages/ride_search_page.dart';
import '../features/ride_search/presentation/pages/ride_results_page.dart';
import '../features/ride_search/presentation/pages/ride_details_page.dart';
import '../features/ride_search/presentation/pages/booking_summary_page.dart';
import '../features/ride_search/presentation/pages/booking_result_page.dart';
import '../features/ride_search/presentation/pages/select_city_page.dart';
import '../features/ride_search/presentation/pages/select_date_page.dart';
import '../features/ride_search/presentation/pages/select_seats_page.dart';
import '../features/ride_search/domain/entities/ride.dart';

// Post Ride (Wizard Pages)
import '../features/post_ride/presentation/pages/post_ride_pickup_address_page.dart';
import '../features/post_ride/presentation/pages/pickup_pinpoint_initial_page.dart';
import '../features/post_ride/presentation/pages/pickup_pinpoint_selected_page.dart';
import '../features/post_ride/presentation/pages/post_ride_dropoff_address_page.dart';
import '../features/post_ride/presentation/pages/dropoff_pinpoint_initial_page.dart';
import '../features/post_ride/presentation/pages/dropoff_pinpoint_selected_page.dart';
import '../features/post_ride/presentation/pages/route_confirmation_page.dart';
import '../features/post_ride/presentation/pages/post_ride_date_page.dart';
import '../features/post_ride/presentation/pages/post_ride_time_page.dart';
import '../features/post_ride/presentation/pages/post_ride_seats_page.dart';
import '../features/post_ride/presentation/pages/enable_instant_booking_page.dart';
import '../features/post_ride/presentation/pages/price_per_seat_page.dart';
import '../features/post_ride/presentation/pages/vehicle_select_page.dart';
import '../features/post_ride/presentation/pages/add_vehicle_page.dart';
import '../features/post_ride/presentation/pages/ride_publish_comments_page.dart';
import '../features/post_ride/presentation/pages/return_ride_prompt_page.dart';

// Return Ride step pages
import '../features/post_ride/presentation/pages/return_ride_date_page.dart';
import '../features/post_ride/presentation/pages/return_ride_time_page.dart';
import '../features/post_ride/presentation/pages/return_ride_seats_page.dart';
import '../features/post_ride/presentation/pages/return_ride_price_page.dart';

// Other Tabs
import '../features/my_rides/presentation/pages/my_rides_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // -------------------------------------------------------------------------
    // AUTH ROUTES (No Bottom Nav)
    // -------------------------------------------------------------------------
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'];
        return LoginPage(from: from);
      },
    ),

    // ✅ FIX: SignupPage has NO `from`
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),

    // ✅ FIX: OtpVerificationPage requires `email`
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) {
        final email = state.extra as String?;
        if (email == null || email.isEmpty) {
          return const _MissingEmailErrorPage();
        }
        return OtpVerificationPage(email: email);
      },
    ),

    // -------------------------------------------------------------------------
    // MAIN APP SHELL (Bottom Nav)
    // -------------------------------------------------------------------------
    ShellRoute(
      builder: (context, state, child) => AppShellScaffold(child: child),
      routes: [
        // 1) SEARCH TAB (Home)
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const RideSearchPage(),
          routes: [
            GoRoute(
              path: 'results',
              name: 'results',
              builder: (context, state) => const RideResultsPage(),
            ),
            GoRoute(
              path: 'ride-details',
              name: 'ride-details',
              builder: (context, state) {
                final ride = state.extra as Ride;
                return RideDetailsPage(ride: ride);
              },
            ),

            // Booking Summary requires auth, but uses BookingProvider internally
            GoRoute(
              path: 'booking-summary',
              name: 'booking-summary',
              redirect: (context, state) {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                if (!auth.isLoggedIn) {
                  final from = Uri.encodeComponent(state.uri.toString());
                  return '/login?from=$from';
                }
                return null;
              },
              builder: (context, state) => const BookingSummaryPage(),
            ),

            // ✅ FIX: BookingResultPage has NO bookingId argument
            GoRoute(
              path: 'booking-result',
              name: 'booking-result',
              builder: (context, state) => const BookingResultPage(),
            ),
          ],
        ),

        // 2) POST RIDE TAB (Wizard Flow)
        GoRoute(
          path: '/post-ride',
          name: 'post-ride',

          // ✅ FIX: redirect ONLY when user hits EXACT /post-ride
          // This prevents breaking /post-ride/time or /post-ride/return/date, etc.
          redirect: (context, state) {
            return state.uri.path == '/post-ride' ? '/post-ride/pickup' : null;
          },

          routes: [
            GoRoute(path: 'pickup', builder: (_, __) => const PostRidePickupAddressPage()),
            GoRoute(path: 'pickup-pin', builder: (_, __) => const PickupPinpointInitialPage()),
            GoRoute(path: 'pickup-pin/selected', builder: (_, __) => const PickupPinpointSelectedPage()),
            GoRoute(path: 'dropoff', builder: (_, __) => const PostRideDropoffAddressPage()),
            GoRoute(path: 'dropoff-pin', builder: (_, __) => const DropoffPinpointInitialPage()),
            GoRoute(path: 'dropoff-pin/selected', builder: (_, __) => const DropoffPinpointSelectedPage()),
            GoRoute(path: 'route', builder: (_, __) => const RouteConfirmationPage()),
            GoRoute(path: 'date', builder: (_, __) => const PostRideDatePage()),
            GoRoute(path: 'time', builder: (_, __) => const PostRideTimePage()),
            GoRoute(path: 'seats', builder: (_, __) => const PostRideSeatsPage()),
            GoRoute(path: 'instant-booking', builder: (_, __) => const EnableInstantBookingPage()),
            GoRoute(path: 'price', builder: (_, __) => const PricePerSeatPage()),
            GoRoute(path: 'vehicle', builder: (_, __) => const VehicleSelectPage()),
            GoRoute(
              path: 'add-vehicle',
              builder: (context, state) {
                final from = state.uri.queryParameters['from'];
                return AddVehiclePage(from: from);
              },
            ),
            GoRoute(path: 'publish-comments', builder: (_, __) => const RidePublishCommentsPage()),

            // Return ride prompt
            GoRoute(
              path: 'return/prompt',
              builder: (context, state) {
                final rideId = state.uri.queryParameters['rideId'];
                return ReturnRidePromptPage(rideId: rideId);
              },
            ),

            // Return ride steps
            GoRoute(path: 'return/date', builder: (_, __) => const ReturnRideDatePage()),
            GoRoute(path: 'return/time', builder: (_, __) => const ReturnRideTimePage()),
            GoRoute(path: 'return/seats', builder: (_, __) => const ReturnRideSeatsPage()),
            GoRoute(path: 'return/price', builder: (_, __) => const ReturnRidePricePage()),
          ],
        ),

        // 3) YOUR RIDES TAB
        GoRoute(
          path: '/my-rides',
          name: 'my-rides',
          builder: (context, state) => const MyRidesPage(),
        ),

        // 4) CHAT TAB
        GoRoute(
          path: '/chat',
          name: 'chat',
          builder: (context, state) => const ChatPage(),
        ),

        // 5) PROFILE TAB
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),

    // Pickers (outside shell)
    GoRoute(
      path: '/select-city',
      name: 'select-city',
      builder: (context, state) {
        final title = state.extra as String? ?? 'Select City';
        return SelectCityPage(title: title);
      },
    ),
    GoRoute(
      path: '/select-date',
      name: 'select-date',
      builder: (context, state) {
        final initialDate = state.extra as DateTime? ?? DateTime.now();
        return SelectDatePage(initialDate: initialDate);
      },
    ),
    GoRoute(
      path: '/select-seats',
      name: 'select-seats',
      builder: (context, state) {
        final initialSeats = state.extra as int? ?? 1;
        return SelectSeatsPage(initialSeats: initialSeats);
      },
    ),
  ],
);

class _MissingEmailErrorPage extends StatelessWidget {
  const _MissingEmailErrorPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'OTP Verification requires an email.\n\n'
                'Fix: Navigate using:\n'
                "context.push('/otp-verification', extra: email);",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
