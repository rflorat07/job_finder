import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../../imports/imports.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AnimatedSmoothIndicator(
      activeIndex: 1,
      count: 3,
      effect: WormEffect(
        dotHeight: Sizes.size8,
        dotWidth: Sizes.size8,
        spacing: SpacingTokens.spacing8,
        activeDotColor: SemanticColorsLight.primary,
        dotColor: SemanticColorsLight.primaryDisabled,
        strokeWidth: 1.5,
      ),
    );
  }
}
