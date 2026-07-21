import 'dart:async';

import '../../../../imports/imports.dart';
import '../../../../shared/services/onboarding_service.dart';
import '../../data/models/models.dart';

class OnboardingController extends ChangeNotifier {
  int _currentPage = 0;

  final PageController _pageController;

  final List<OnboardingItemModel> items = const [
    OnboardingItemModel(
      titleKey: 'onboarding.onboarding_title_1',
      subtitleKey: 'onboarding.onboarding_subtitle_1',
      imagePath: 'assets/images/onboarding/onboarding_1.png',
    ),
    OnboardingItemModel(
      titleKey: 'onboarding.onboarding_title_2',
      subtitleKey: 'onboarding.onboarding_subtitle_2',
      imagePath: 'assets/images/onboarding/onboarding_2.png',
    ),
    OnboardingItemModel(
      titleKey: 'onboarding.onboarding_title_3',
      subtitleKey: 'onboarding.onboarding_subtitle_3',
      imagePath: 'assets/images/onboarding/onboarding_3.png',
    ),
  ];

  int get currentPage => _currentPage;

  PageController get pageController => _pageController;

  bool get isLastPage => _currentPage == items.length - 1;

  OnboardingController() : _pageController = PageController(initialPage: 0);

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    if (_currentPage < items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      unawaited(onboardingService.markCompleted());
      // Navigate to login page
      context.go(AppRoutes.login);
    }
  }

  void skip(BuildContext context) {
    unawaited(onboardingService.markCompleted());
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
