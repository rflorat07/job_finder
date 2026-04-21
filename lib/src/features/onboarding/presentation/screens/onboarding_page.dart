import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/imports.dart';

import 'widgets/widgets.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final _onboardingData = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          child: Column(
            spacing: SpacingTokens.spacing32,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Skipping the onboarding flow
              const OnBoardingSkip(),

              Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.70, // ajusta este valor (0.0 a 1.0)
                  child: PageView.builder(
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return OnboardingItem(
                        image: data['image']!,
                        title: data['title']!,
                        subtitle: data['subtitle']!,
                      );
                    },
                  ),
                ),
              ),

              /// Dot Navigation SmoothPageIndicator
              const OnBoardingDotNavigation(),

              DSButton(
                label: '',
                iconOnly: true,
                iconLeft: IconsaxPlusLinear.arrow_right_3,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
