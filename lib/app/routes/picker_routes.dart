import 'package:go_router/go_router.dart';

import '../../features/ride_search/presentation/pages/select_city_page.dart';
import '../../features/ride_search/presentation/pages/select_date_page.dart';
import '../../features/ride_search/presentation/pages/select_seats_page.dart';

List<RouteBase> pickerRoutes() => [
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
    ];
