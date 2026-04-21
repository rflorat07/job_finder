import 'package:job_finder/src/imports/imports.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: const Text('Skip'),
        ),
      ],
    );
  }
}
