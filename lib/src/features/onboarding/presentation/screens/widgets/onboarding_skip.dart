import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
    required this.onSkip,
    required this.isLastPage,
  });

  final bool isLastPage;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: !isLastPage,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: TextButton(
            onPressed: onSkip,
            child: Text(context.tr('shared.skip')),
          ),
        ),
      ],
    );
  }
}
