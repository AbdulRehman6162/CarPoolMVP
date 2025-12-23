import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/platform/chat_launcher.dart';
import '../services/url_launcher_chat_launcher.dart';

// ------------------- RIDE SEARCH -------------------
import '../features/ride_search/data/datasources/ride_remote_data_source.dart';
import '../features/ride_search/data/repositories/ride_repository_impl.dart';
import '../features/ride_search/domain/usecases/book_ride_usecase.dart';
import '../features/ride_search/domain/usecases/search_rides_usecase.dart';
import '../features/ride_search/presentation/provider/booking_provider.dart';
import '../features/ride_search/presentation/provider/ride_search_provider.dart';

// ------------------- AUTH -------------------
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

// ------------------- VEHICLE -------------------
import '../features/vehicle/data/repositories/vehicle_repository_memory.dart';
import '../features/vehicle/presentation/providers/vehicle_provider.dart';

// ------------------- POST RIDE -------------------
import '../features/post_ride/data/repositories/ride_draft_repository_memory.dart';
import '../features/post_ride/data/repositories/route_repository_mock.dart';
import '../features/post_ride/data/repositories/ride_publish_repository_mock.dart';

import '../features/post_ride/application/usecases/create_new_draft_usecase.dart';
import '../features/post_ride/application/usecases/save_draft_usecase.dart';
import '../features/post_ride/application/usecases/get_route_options_usecase.dart';
import '../features/post_ride/application/usecases/publish_ride_usecase.dart';
import '../features/post_ride/application/usecases/publish_return_ride_usecase.dart';
import '../features/post_ride/application/usecases/ensure_publish_eligibility_usecase.dart';

import '../features/post_ride/presentation/providers/post_ride_draft_provider.dart';
import '../features/post_ride/presentation/providers/post_ride_publish_provider.dart';

/// Minimal DI module for Provider-based apps.
/// Keeps `main.dart` small and prevents it from growing into a wiring monolith.
class AppDI {
  static List<SingleChildWidget> providers() {
    // ---------------------------------------------------------------------------
    // DATA LAYER (Repos + Datasources)
    // ---------------------------------------------------------------------------

    final authRepo = AuthRepositoryImpl();

    final rideRemote = RideRemoteDataSource();
    final rideRepo = RideRepositoryImpl(rideRemote);

    final vehicleRepo = VehicleRepositoryMemory();

    final draftRepo = RideDraftRepositoryMemory();
    final routeRepo = RouteRepositoryMock();
    final publishRepo = RidePublishRepositoryMock();

    // ---------------------------------------------------------------------------
    // USE CASES
    // ---------------------------------------------------------------------------

    final searchRidesUseCase = SearchRidesUseCase(rideRepo);
    final bookRideUseCase = BookRideUseCase(rideRepo);

    final createDraftUseCase = CreateNewDraftUseCase(draftRepo);
    final saveDraftUseCase = SaveDraftUseCase(draftRepo);
    final getRoutesUseCase = GetRouteOptionsUseCase(routeRepo);
    final publishRideUseCase = PublishRideUseCase(publishRepo);
    final publishReturnRideUseCase = PublishReturnRideUseCase(publishRepo);
    final ensurePublishEligibilityUseCase = EnsurePublishEligibilityUseCase(authRepo, vehicleRepo);

    // Platform services
    final ChatLauncher chatLauncher = UrlLauncherChatLauncher();

    // ---------------------------------------------------------------------------
    // PROVIDERS
    // ---------------------------------------------------------------------------
    return [
      // Auth
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(authRepo),
      ),

      // Ride Search
      ChangeNotifierProvider<RideSearchProvider>(
        create: (_) => RideSearchProvider(searchRidesUseCase),
      ),
      ChangeNotifierProvider<BookingProvider>(
        create: (_) => BookingProvider(bookRideUseCase),
      ),

      // Vehicle
      ChangeNotifierProvider<VehicleProvider>(
        create: (_) => VehicleProvider(vehicleRepo)..refresh(),
      ),

      // Post Ride
      Provider<EnsurePublishEligibilityUseCase>(
        create: (_) => ensurePublishEligibilityUseCase,
      ),
      ChangeNotifierProvider<PostRideDraftProvider>(
        create: (_) => PostRideDraftProvider(
          createDraftUseCase,
          saveDraftUseCase,
          getRoutesUseCase,
        ),
      ),
      ChangeNotifierProvider<PostRidePublishProvider>(
        create: (_) => PostRidePublishProvider(
          publishRideUseCase,
          publishReturnRideUseCase,
        ),
      ),

      // Platform boundary services
      Provider<ChatLauncher>(
        create: (_) => chatLauncher,
      ),
    ];
  }
}
