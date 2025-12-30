import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // No manual navigation here, we listen to the provider in build/listen
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the provider's state
    ref.listen(splashControllerProvider, (previous, next) {
      next.when(
        data: (isLoggedIn) {
          if (isLoggedIn) {
            context.go('/'); // Home
          } else {
            context.go('/login'); // Login
          }
        },
        error: (err, stack) {
          // Handle error (maybe retry or go to login)
          context.go('/login');
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Placeholder
            Icon(
              Icons.flutter_dash,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            const Text(
              'WAC Project',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
