import 'package:flutter/material.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSAuthHeaderBaseLayout extends StatelessWidget {
  const DSAuthHeaderBaseLayout({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  final String title;
  final String subtitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              titleTextStyle ??
              context.dsTextTheme.headlineLarge?.copyWith(
                color: context.dsColors.onPrimary,
                height: TypographyTokens.lineHeightRelaxed,
              ),
        ),
        Text(
          subtitle,
          style:
              subtitleTextStyle ??
              context.dsTextTheme.bodySmall?.copyWith(
                color: const Color(PrimitiveColors.greyscale25),
                height: TypographyTokens.lineHeightRelaxed,
              ),
        ),
      ],
    );
  }
}
