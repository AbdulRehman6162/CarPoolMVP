import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The single place that owns the bottom navigation UI.
///
/// SOLID:
/// - SRP: Only responsible for rendering and handling bottom-nav interactions.
/// - OCP: Add a new tab by extending [_tabs] without changing callers.
/// - DIP: Depends on GoRouter abstraction (context.go) rather than concrete pages.
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  static final List<_TabSpec> _tabs = <_TabSpec>[
    _TabSpec(
      label: 'Search',
      icon: Icons.search,
      location: '/',
    ),
    _TabSpec(
      label: 'Post Ride',
      icon: Icons.add_circle_outline,
      location: '/post-ride',
    ),
    _TabSpec(
      label: 'Your rides',
      icon: Icons.directions_car,
      location: '/my-rides',
    ),
    _TabSpec(
      label: 'Chat',
      icon: Icons.chat_bubble_outline,
      location: '/chat',
    ),
    _TabSpec(
      label: 'Profile',
      icon: Icons.person_outline,
      location: '/profile',
    ),
  ];

  int _tabForLocation(String path) {
    // Post Ride wizard + return ride flows
    if (path == '/post-ride' || path.startsWith('/post-ride/')) return 1;

    // Other authenticated tabs
    if (path == '/my-rides' || path.startsWith('/my-rides/')) return 2;
    if (path == '/chat' || path.startsWith('/chat/')) return 3;
    if (path == '/profile' || path.startsWith('/profile/')) return 4;

    // Search tab:
    // In your router, Search lives at '/' and includes nested routes like:
    // /results, /ride-details, /booking-summary, /booking-result, etc.
    // The safest clean rule: anything not belonging to another tab defaults to Search.
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Use .path to ignore query params for tab matching
    final String path = GoRouterState.of(context).uri.path;
    final int currentIndex = _tabForLocation(path);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          final target = _tabs[index].location;

          // Behavior:
          // - Tapping a tab always navigates to that tab root (resets flow).
          // - For Post Ride, /post-ride is fine because router redirects to pickup.
          if (path != target) {
            context.go(target);
          } else {
            // Optional: re-go to same target to reset internal nested stacks.
            // Uncomment if you want "tap active tab resets" behavior always.
            // context.go(target);
          }
        },
        items: _tabs
            .map(
              (t) => BottomNavigationBarItem(
            icon: Icon(t.icon),
            label: t.label,
          ),
        )
            .toList(growable: false),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({
    required this.label,
    required this.icon,
    required this.location,
  });

  final String label;
  final IconData icon;
  final String location;
}
