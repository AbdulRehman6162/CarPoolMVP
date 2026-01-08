import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/platform/chat_launcher.dart';
import '../services/url_launcher_chat_launcher.dart';
import '../core/session/session_provider.dart';
import '../core/session/session_repository.dart';
import '../core/auth_flow/auth_flow_provider.dart';
import '../core/platform/biometric_auth.dart';
import '../services/noop_biometric_auth.dart';

// ------------------- MY RIDES -------------------
import '../features/my_rides/data/datasources/my_rides_remote_data_source.dart';
import '../features/my_rides/data/repositories/my_rides_repository_impl.dart';
import '../features/my_rides/application/usecases/get_archived_rides_usecase.dart';
import '../features/my_rides/application/usecases/get_my_ride_details_usecase.dart';
import '../features/my_rides/application/usecases/get_my_rides_usecase.dart';
import '../features/my_rides/presentation/providers/my_rides_provider.dart';

// ------------------- RIDE SEARCH -------------------
import '../features/ride_search/data/datasources/ride_remote_data_source.dart';
import '../features/ride_search/data/repositories/ride_repository_impl.dart';
import '../features/ride_search/application/usecases/book_ride_usecase.dart';
import '../features/ride_search/application/usecases/search_rides_usecase.dart';
import '../features/ride_search/presentation/provider/booking_provider.dart';
import '../features/ride_search/presentation/provider/ride_search_provider.dart';

// ------------------- AUTH -------------------
import '../core/platform/secure_kv_store.dart';
import '../services/flutter_secure_kv_store.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/datasources/supabase_auth_remote_data_source.dart';
import '../features/auth/data/datasources/auth_mock_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/application/adapters/auth_session_repository.dart';
import '../features/auth/data/strategies/auth_strategy_registry.dart';
import '../features/auth/data/strategies/auth_strategy.dart';
import '../features/auth/data/strategies/email_password_signin_strategy.dart';
import '../features/auth/data/strategies/email_password_signup_strategy.dart';
import '../features/auth/data/strategies/otp_verify_strategy.dart';
import '../features/auth/data/strategies/oauth_signin_strategy.dart';
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

        // Auth wiring (DIP-friendly)
    final SecureKvStore secureKvStore = FlutterSecureKvStore();
    final authLocalDataSource = AuthLocalDataSource(secureKvStore);
    final AuthRemoteDataSource authRemoteDataSource = () {
      try {
        return SupabaseAuthRemoteDataSource(Supabase.instance.client);
      } catch (_) {
        // Supabase not initialised (e.g., tests) – fall back to mock.
        return MockAuthRemoteDataSource();
      }
    }();
    final authStrategies = <AuthStrategy>[
      EmailPasswordSignInStrategy(authRemoteDataSource),
      EmailPasswordSignUpStrategy(authRemoteDataSource),
      OtpVerifyStrategy(authRemoteDataSource),
      OAuthSignInStrategy(),
    ];
    final authRegistry = AuthStrategyRegistry(authStrategies);
    final authRepo = AuthRepositoryImpl(
      remote: authRemoteDataSource,
      local: authLocalDataSource,
      registry: authRegistry,
    );

    final SessionRepository sessionRepository = AuthSessionRepository(authRepo);

final rideRemote = RideRemoteDataSource();
    final rideRepo = RideRepositoryImpl(rideRemote);

    final vehicleRepo = VehicleRepositoryMemory();

    final draftRepo = RideDraftRepositoryMemory();
    final routeRepo = RouteRepositoryMock();
    final publishRepo = RidePublishRepositoryMock();
final myRidesRemote = MyRidesRemoteDataSource();
final myRidesRepo = MyRidesRepositoryImpl(myRidesRemote);

final getMyRidesUseCase = GetMyRidesUseCase(myRidesRepo);
final getArchivedRidesUseCase = GetArchivedRidesUseCase(myRidesRepo);
final getMyRideDetailsUseCase = GetMyRideDetailsUseCase(myRidesRepo);

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
      Provider<AuthRepositoryImpl>(
        create: (_) => authRepo,
        dispose: (_, repo) => repo.dispose(),
      ),
      Provider<SessionRepository>(
        create: (_) => sessionRepository,
      ),
      ChangeNotifierProvider<SessionProvider>(
        create: (ctx) => SessionProvider(ctx.read<SessionRepository>()),
      ),
      Provider<BiometricAuth>(
        create: (_) => NoopBiometricAuth(),
      ),
      ChangeNotifierProvider<AuthFlowProvider>(
        create: (_) => AuthFlowProvider(),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (ctx) => AuthProvider(
          ctx.read<AuthRepositoryImpl>(),
          authFlow: ctx.read<AuthFlowProvider>(),
          biometricAuth: ctx.read<BiometricAuth>(),
        ),
      ),

      // Ride Search
      ChangeNotifierProvider<RideSearchProvider>(
        create: (_) => RideSearchProvider(searchRidesUseCase),
      ),
      ChangeNotifierProvider<BookingProvider>(
        create: (_) => BookingProvider(bookRideUseCase),
      ),

      ChangeNotifierProvider<MyRidesProvider>(
        create: (_) => MyRidesProvider(
          getMyRidesUseCase,
          getArchivedRidesUseCase,
          getMyRideDetailsUseCase,
        ),
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
