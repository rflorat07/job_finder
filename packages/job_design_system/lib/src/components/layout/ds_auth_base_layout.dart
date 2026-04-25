import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSAuthBaseLayout extends StatelessWidget {
  const DSAuthBaseLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.containerColor,
    this.backgroundColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  ///  Base layout title
  final String title;

  ///  Base layout title text style
  final TextStyle? titleTextStyle;

  ///  Base layout subtitle
  final String subtitle;

  ///  Base layout subtitle text style
  final TextStyle? subtitleTextStyle;

  ///  Base layout child widget
  final Widget child;

  ///  Base layout background color
  final Color? backgroundColor;

  ///  Base layout container color
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
                vertical: SpacingTokens.spacing20,
              ),
              child: Column(
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
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerColor ?? context.dsColors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Sizes.size24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Sizes.size24),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      SpacingTokens.spacing24,
                      SpacingTokens.spacing40,
                      SpacingTokens.spacing24,
                      SpacingTokens.spacing40,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'DSAuthBaseLayout Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSAuthBaseLayout Preview - Dark', brightness: Brightness.dark)
Widget dsAuthBaseLayoutLightDarkPreview() {
  return DSAuthBaseLayout(
    backgroundColor: Colors.green,
    title: 'Get Started',
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    subtitle:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt.',
    subtitleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    containerColor: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SpacingTokens.spacing24,
      children: [
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
