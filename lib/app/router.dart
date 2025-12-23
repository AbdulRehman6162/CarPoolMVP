import 'package:go_router/go_router.dart';

import 'routes/auth_routes.dart';
import 'routes/picker_routes.dart';
import 'routes/shell_routes.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ...authRoutes(),
    appShellRoute(),
    ...pickerRoutes(),
  ],
);
