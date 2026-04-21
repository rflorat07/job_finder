import 'package:flutter/material.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SpacingTokens.spacing40,

      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.asset(image)),

        Column(
          spacing: SpacingTokens.spacing16,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: context.dsTextTheme.headlineLarge?.copyWith(
                height: TypographyTokens.lineHeightRelaxed,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: context.dsTextTheme.bodySmall?.copyWith(
                height: TypographyTokens.lineHeightExtraRelaxed,
                color: context.dsColors.secondary,
              ),
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
