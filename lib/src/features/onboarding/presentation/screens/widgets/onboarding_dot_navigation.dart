import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../../imports/imports.dart';
import '../../providers/onboarding_provider.dart';

class OnBoardingDotNavigation extends ConsumerWidget {
  const OnBoardingDotNavigation({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(
      onboardingProvider.select((state) => state.currentPage),
    );

    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: WormEffect(
        dotHeight: Sizes.size8,
        dotWidth: Sizes.size8,
        spacing: SpacingTokens.spacing8,
        activeDotColor: context.dsColors.primary,
        dotColor: context.dsIsDarkMode
            ? SemanticColorsDark.primaryDisabled
            : SemanticColorsLight.primaryDisabled,
        strokeWidth: 1.5,
      ),
    );
  }
}
