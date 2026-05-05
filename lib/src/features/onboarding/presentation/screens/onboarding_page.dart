import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/imports.dart';

import 'widgets/widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _skip() {
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == 2;

    final onboardingData = [
      {
        'title': 'onboarding.onboarding_title_1'.tr(),
        'subtitle': 'onboarding.onboarding_subtitle_1'.tr(),
        'image': 'assets/images/onboarding/onboarding_1.png',
      },
      {
        'title': 'onboarding.onboarding_title_2'.tr(),
        'subtitle': 'onboarding.onboarding_subtitle_2'.tr(),
        'image': 'assets/images/onboarding/onboarding_2.png',
      },
      {
        'title': 'onboarding.onboarding_title_3'.tr(),
        'subtitle': 'onboarding.onboarding_subtitle_3'.tr(),
        'image': 'assets/images/onboarding/onboarding_3.png',
      },
    ];

    return Scaffold(
      backgroundColor: context.dsColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          child: Column(
            children: [
              const SizedBox(height: SpacingTokens.spacing8),

              // Skip button
              OnBoardingSkip(onSkip: _skip),

              const SizedBox(height: SpacingTokens.spacing16),

              // PageView - takes all available space
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return OnboardingItem(
                      image: data['image']!,
                      title: data['title']!,
                      subtitle: data['subtitle']!,
                    );
                  },
                ),
              ),

              const SizedBox(height: SpacingTokens.spacing32),

              // Dot indicators
              OnBoardingDotNavigation(
                count: onboardingData.length,
                activeIndex: _currentPage,
              ),

              const SizedBox(height: SpacingTokens.spacing48),

              // Next button
              DSButton(
                label: isLastPage ? context.tr('shared.get_started') : '',
                iconOnly: !isLastPage,
                type: DSButtonType.primary,
                size: DSButtonSize.large,
                iconLeft: isLastPage ? null : IconsaxPlusLinear.arrow_right_3,
                onPressed: _nextPage,
              ),

              const SizedBox(height: SpacingTokens.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
