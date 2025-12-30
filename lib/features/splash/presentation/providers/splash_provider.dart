import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simulates checking for an auth token or initial app configuration
// Returns true if authenticated, false otherwise.
final splashControllerProvider = FutureProvider.autoDispose<bool>((ref) async {
  // Simulate network delay (e.g., checking local storage or API)
  await Future.delayed(const Duration(seconds: 2));

  // For now, hardcode to false (not logged in) to test the flow to Login screen.
  // Later this will check actual SharedPreferences or SecureStorage.
  return false;
});
