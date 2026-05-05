import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../../imports/imports.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
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
