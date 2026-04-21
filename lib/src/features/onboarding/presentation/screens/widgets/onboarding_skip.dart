import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/imports.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: SpacingTokens.spacing24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: Text('onboarding.skip'.tr()),
          ),
        ],
      ),
    );
  }
}
