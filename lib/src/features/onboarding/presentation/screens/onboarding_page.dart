import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/imports.dart';

import '../providers/onboarding_provider.dart';
import 'widgets/widgets.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingProvider.notifier);
    final isLastPage = ref.watch(
      onboardingProvider.select((state) => state.isLastPage),
    );

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
              OnBoardingSkip(onSkip: () => notifier.skip(context)),

              const SizedBox(height: SpacingTokens.spacing16),

              // PageView - takes all available space
              Expanded(
                child: PageView.builder(
                  controller: notifier.pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: notifier.onPageChanged,
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
              OnBoardingDotNavigation(count: onboardingData.length),

              const SizedBox(height: SpacingTokens.spacing48),

              // Next button
              DSButton(
                label: isLastPage ? 'onboarding.get_started'.tr() : '',
                iconOnly: !isLastPage,
                type: DSButtonType.primary,
                size: DSButtonSize.large,
                iconLeft: isLastPage ? null : IconsaxPlusLinear.arrow_right_3,
                onPressed: () => notifier.nextPage(context),
              ),

              const SizedBox(height: SpacingTokens.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
