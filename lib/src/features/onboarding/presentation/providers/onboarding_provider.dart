import 'package:job_finder/src/imports/imports.dart';

/// State for the onboarding flow.
class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.totalPages = 3,
  });

  final int currentPage;
  final int totalPages;

  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages];
}

/// Notifier that manages the onboarding page state and PageController.
class OnboardingNotifier extends Notifier<OnboardingState> {
  late final PageController pageController;

  @override
  OnboardingState build() {
    pageController = PageController();

    ref.onDispose(() {
      pageController.dispose();
    });

    return const OnboardingState();
  }

  /// Called when the PageView page changes via swipe.
  void onPageChanged(int index) {
    state = state.copyWith(currentPage: index);
  }

  /// Advances to the next page or completes the onboarding.
  void nextPage(BuildContext context) {
    if (state.isLastPage) {
      context.go(AppRoutes.login);
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Skips the onboarding and navigates to login.
  void skip(BuildContext context) {
    context.go(AppRoutes.login);
  }
}

/// Riverpod provider for the onboarding state.
final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
