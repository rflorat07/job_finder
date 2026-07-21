import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the user has already completed onboarding.
final OnboardingService onboardingService = OnboardingService._();

class OnboardingService {
  static const String _key = 'has_completed_onboarding';

  OnboardingService._();

  /// Returns true when onboarding was already completed on this device.
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Marks onboarding as completed.
  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
