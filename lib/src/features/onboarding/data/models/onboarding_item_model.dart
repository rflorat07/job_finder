// lib/src/features/onboarding/domain/models/onboarding_item_model.dart
class OnboardingItemModel {
  final String titleKey;
  final String subtitleKey;
  final String imagePath;

  const OnboardingItemModel({
    required this.titleKey,
    required this.subtitleKey,
    required this.imagePath,
  });
}
