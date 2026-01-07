import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import 'routes/auth_routes.dart';
import 'routes/picker_routes.dart';
import 'routes/shell_routes.dart';

GoRouter createRouter({required AuthProvider auth}) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) {
      if (!auth.isInitialized) {
        return null;
      }

      final path = state.uri.path;
      final isLoggedIn = auth.isLoggedIn;

      final isLogin = path == '/login';
      final isSignup = path == '/signup';

      final requiresAuth =
          path.startsWith('/my-rides') || path.startsWith('/profile') || path.startsWith('/post-ride');

      if (!isLoggedIn && requiresAuth) {
        final from = Uri.encodeComponent(state.uri.toString());
        return '/login?from=$from';
      }

      if (isLoggedIn && (isLogin || isSignup)) {
        return '/';
      }

      return null;
    },
    routes: [
      ...authRoutes(),
      appShellRoute(),
      ...pickerRoutes(),
    ],
  );
}
