import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/navigation/bottom_navigation.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/screens/home/main.dart';
import 'package:mobile/screens/login/login_screen.dart';
import 'package:mobile/screens/map/map_screen.dart';
import 'package:mobile/screens/menu/menu_screen.dart';
import 'package:mobile/screens/payment/payment_screen.dart';
import 'package:mobile/screens/permissions/permission_screen.dart';
import 'package:mobile/screens/profile/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = authState.value;
      final initialized = session?.initialized ?? false;
      final loggedIn = session?.isAuthenticated ?? false;

      final location = state.matchedLocation;

      final isLogin = location == '/login';
      final isRoot = location == '/';

      if (!initialized) {
        return null;
      }

      if (!loggedIn && !isLogin && !isRoot) {
        return '/login';
      }

      if (loggedIn && (isLogin || isRoot)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const PermissionScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
          GoRoute(
            path: '/menu',
            builder: (context, state) => const MenuScreen(),
          ),
          GoRoute(
            path: '/payment',
            builder: (context, state) => const PaymentScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
