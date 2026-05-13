import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSSetupAccountBaseLayout extends StatelessWidget {
  const DSSetupAccountBaseLayout({
    super.key,
    required this.title,
    required this.child,
    required this.currentStep,
    required this.totalSteps,
    this.icon,
    this.subtitle,
    this.onPressed,
    this.bottomAction,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  /// Base layout title
  final String title;

  /// Base layout title text style
  final TextStyle? titleTextStyle;

  /// Base layout subtitle
  final String? subtitle;

  /// Base layout subtitle text style
  final TextStyle? subtitleTextStyle;

  /// Base layout child widget (the specific content of this step)
  final Widget child;

  /// Optional widget pinned to the bottom (e.g., a "Continue" button)
  final Widget? bottomAction;

  /// Base layout back button icon (default: Icons.arrow_back_ios_new)
  final IconData? icon;

  /// Base layout back button onPressed callback. If null, the button is hidden.
  final VoidCallback? onPressed;

  /// Current step in the setup process (starts at 1)
  final int currentStep;

  /// Total number of steps in the setup process
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(PrimitiveColors.greyscale25),
      bottomNavigationBar: bottomAction != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizesTokens.size24,
                ),
                child: bottomAction,
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: currentStep / totalSteps),
            const SizedBox(height: SizesTokens.size24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizesTokens.size24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (onPressed != null) ...[
                      DSButton(
                        label: '',
                        onPressed: onPressed,
                        iconOnly: true,
                        type: DSButtonType.secondary,
                        iconLeft: icon ?? Icons.arrow_back_ios_new,
                      ),
                      const SizedBox(height: SizesTokens.size24),
                    ],
                    Text(
                      title,
                      style:
                          titleTextStyle ??
                          context.dsTextTheme.headlineLarge?.copyWith(
                            height: TypographyTokens.lineHeightRelaxed,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: SizesTokens.size4),
                      Text(
                        subtitle!,
                        style:
                            subtitleTextStyle ??
                            context.dsTextTheme.bodySmall?.copyWith(
                              height: TypographyTokens.lineHeightExtraRelaxed,
                              fontWeight: TypographyTokens.fontWeightRegular,
                              color: context.dsColors.secondary,
                            ),
                      ),
                    ],
                    const SizedBox(height: SizesTokens.size32),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(
  name: 'DsSetupAccountBaseLayout Preview - Light',
  brightness: Brightness.light,
)
//@Preview(name: 'DsSetupAccountBaseLayout Preview - Dark', brightness: Brightness.dark)
Widget dsSetupAccountBaseLayoutLightDarkPreview() {
  return DSSetupAccountBaseLayout(
    currentStep: 1,
    totalSteps: 4,
    title: 'Where do you come from?',
    subtitle:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt.',
    onPressed: () {},
    bottomAction: DSButton(label: 'Continue', onPressed: () {}),
    child: const Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt.',
    ),
  );
}
