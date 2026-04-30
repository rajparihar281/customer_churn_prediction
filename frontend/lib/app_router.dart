// lib/app_router.dart
import 'package:go_router/go_router.dart';
import 'screens/customer_detail_screen.dart';
import 'main_scaffold.dart';
import 'screens/splash_screen.dart';

final router = GoRouter(
  // 1. Change the initial location to the splash screen's route
  initialLocation: '/',
  routes: [
    // 2. Add a new route for the splash screen
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    // This ShellRoute builds the UI with the BottomNavigationBar for the main app
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainScaffold(initialIndex: 0),
        ),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const MainScaffold(initialIndex: 1),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const MainScaffold(initialIndex: 2),
        ),
        GoRoute(
          path: '/features',
          builder: (context, state) => const MainScaffold(initialIndex: 3),
        ),
      ],
    ),
    // This top-level route is for the detail screen, which doesn't have the nav bar
    GoRoute(
      path: '/customer/:id',
      builder: (context, state) {
        final customerId = state.pathParameters['id']!;
        return CustomerDetailScreen(customerId: customerId);
      },
    ),
  ],
);
