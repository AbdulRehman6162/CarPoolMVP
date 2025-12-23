import 'package:go_router/go_router.dart';

import '../../core/widgets/app_shell_scaffold.dart';

// Ride Search (Home)
import '../../features/ride_search/domain/entities/ride.dart';
import '../../features/ride_search/presentation/pages/booking_result_page.dart';
import '../../features/ride_search/presentation/pages/booking_summary_page.dart';
import '../../features/ride_search/presentation/pages/ride_details_page.dart';
import '../../features/ride_search/presentation/pages/ride_results_page.dart';
import '../../features/ride_search/presentation/pages/ride_search_page.dart';

// Post Ride (Wizard Pages)
import '../../features/post_ride/presentation/pages/add_vehicle_page.dart';
import '../../features/post_ride/presentation/pages/dropoff_pinpoint_initial_page.dart';
import '../../features/post_ride/presentation/pages/dropoff_pinpoint_selected_page.dart';
import '../../features/post_ride/presentation/pages/enable_instant_booking_page.dart';
import '../../features/post_ride/presentation/pages/pickup_pinpoint_initial_page.dart';
import '../../features/post_ride/presentation/pages/pickup_pinpoint_selected_page.dart';
import '../../features/post_ride/presentation/pages/post_ride_date_page.dart';
import '../../features/post_ride/presentation/pages/post_ride_dropoff_address_page.dart';
import '../../features/post_ride/presentation/pages/post_ride_pickup_address_page.dart';
import '../../features/post_ride/presentation/pages/post_ride_seats_page.dart';
import '../../features/post_ride/presentation/pages/post_ride_time_page.dart';
import '../../features/post_ride/presentation/pages/price_per_seat_page.dart';
import '../../features/post_ride/presentation/pages/return_ride_date_page.dart';
import '../../features/post_ride/presentation/pages/return_ride_price_page.dart';
import '../../features/post_ride/presentation/pages/return_ride_prompt_page.dart';
import '../../features/post_ride/presentation/pages/return_ride_seats_page.dart';
import '../../features/post_ride/presentation/pages/return_ride_time_page.dart';
import '../../features/post_ride/presentation/pages/ride_publish_comments_page.dart';
import '../../features/post_ride/presentation/pages/route_confirmation_page.dart';
import '../../features/post_ride/presentation/pages/vehicle_select_page.dart';

// Other Tabs
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/my_rides/presentation/pages/my_rides_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

RouteBase appShellRoute() => ShellRoute(
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
            GoRoute(
              path: 'booking-summary',
              name: 'booking-summary',
              builder: (context, state) {
                final ride = state.extra as Ride;
                return BookingSummaryPage(ride: ride);
              },
            ),
            GoRoute(
              path: 'booking-result',
              name: 'booking-result',
              builder: (context, state) => const BookingResultPage(),
            ),
          ],
        ),

        // 2) POST RIDE TAB
        GoRoute(
          path: '/post-ride',
          name: 'post-ride',
          builder: (context, state) => const PostRidePickupAddressPage(),
          routes: [
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
    );
