import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/find_id_screen.dart';
import '../../features/auth/presentation/screens/find_password_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/church/presentation/screens/church_search_screen.dart';
import '../../features/church/presentation/screens/church_request_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/find_id',
        builder: (context, state) => const FindIdScreen(),
      ),
      GoRoute(
        path: '/find_password',
        builder: (context, state) => const FindPasswordScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/church_search',
        builder: (context, state) => const ChurchSearchScreen(),
      ),
      GoRoute(
        path: '/church_request',
        builder: (context, state) => const ChurchRequestScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
  );
});
