import 'package:go_router/go_router.dart';

import '../core/session/session_provider.dart';
import 'routes/auth_routes.dart';
import 'routes/picker_routes.dart';
import 'routes/shell_routes.dart';

GoRouter createRouter({required SessionProvider session}) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: session,
    redirect: (context, state) {
      if (!session.isInitialized) {
        return null;
      }

      final path = state.uri.path;
      final isLoggedIn = session.isAuthenticated;

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
