import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/login/auth_provider.dart';
import '../../screens/login/login_screen.dart';
import '../../navigation/bottom_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = authState.value ?? false;

      if (!loggedIn && state.matchedLocation != '/login') {
        return '/login';
      }

      if (loggedIn && state.matchedLocation == '/login') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const BottomNavigation()),
    ],
  );
});
