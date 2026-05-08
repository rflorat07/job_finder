import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSAuthBaseLayout extends StatelessWidget {
  const DSAuthBaseLayout({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.subtitle,
    this.onPressed,
    this.showBackButton,
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
  final String? subtitle;

  ///  Base layout subtitle text style
  final TextStyle? subtitleTextStyle;

  ///  Base layout child widget
  final Widget child;

  ///  Base layout show back button (default: false)
  final bool? showBackButton;

  ///  Base layout background color
  final Color? backgroundColor;

  ///  Base layout container color
  final Color? containerColor;

  ///  Base layout back button icon (default: Icons.arrow_back_ios_new)
  final IconData? icon;

  ///  Base layout back button onPressed callback
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        // On iOS, .light makes the icons white
        // On Android, we configure it specifically:
        statusBarColor: Colors.transparent, // Transparent background
        statusBarIconBrightness: Brightness.light, // White icons (Android)
        statusBarBrightness: Brightness.dark, // Required for white icons on iOS
      ),
      child: Scaffold(
        backgroundColor: backgroundColor ?? context.dsColors.primary,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (showBackButton ?? false)
                  ? _AuthBackButtonHeader(
                      title: title,
                      icon: icon,
                      titleTextStyle: titleTextStyle,
                      onPressed: onPressed,
                    )
                  : _AuthHeader(
                      title: title,
                      subtitle: subtitle,
                      titleTextStyle: titleTextStyle,
                      subtitleTextStyle: subtitleTextStyle,
                    ),
              _AuthScrollableContainer(
                containerColor:
                    containerColor ?? context.dsColors.secondaryContainer,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.title,
    this.titleTextStyle,
    this.subtitle,
    this.subtitleTextStyle,
  });

  final String title;
  final String? subtitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          if (subtitle != null)
            Text(
              subtitle!,
              style:
                  subtitleTextStyle ??
                  context.dsTextTheme.bodySmall?.copyWith(
                    color: const Color(PrimitiveColors.greyscale25),
                    height: TypographyTokens.lineHeightRelaxed,
                  ),
            ),
        ],
      ),
    );
  }
}

class _AuthBackButtonHeader extends StatelessWidget {
  const _AuthBackButtonHeader({
    this.icon,
    this.onPressed,
    this.titleTextStyle,
    required this.title,
  });

  final String title;
  final IconData? icon;
  final TextStyle? titleTextStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
        vertical: SpacingTokens.spacing20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DSButton(
            label: '',
            iconOnly: true,
            size: DSButtonSize.small,
            type: DSButtonType.back,
            iconLeft: icon ?? Icons.arrow_back_ios_new,
            onPressed: onPressed ?? () => Navigator.maybePop(context),
          ),
          Text(
            title,
            style:
                titleTextStyle ??
                context.dsTextTheme.bodyLarge?.copyWith(
                  color: context.dsColors.onPrimary,
                  height: TypographyTokens.lineHeightRelaxed,
                  fontWeight: TypographyTokens.fontWeightBold,
                ),
          ),
          const SizedBox(
            width: Sizes.size40,
          ), // Placeholder to balance the back button
        ],
      ),
    );
  }
}

class _AuthScrollableContainer extends StatelessWidget {
  const _AuthScrollableContainer({required this.child, this.containerColor});

  final Widget child;
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
          // 1. LayoutBuilder to measure exactly the available white space
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // 2. ConstrainedBox ensures the content is at least as tall as the screen
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  // 3. IntrinsicHeight is the key that allows using Spacer() inside a ScrollView
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.spacing24,
                        vertical: SpacingTokens.spacing32,
                      ),
                      child:
                          child, // Your content (GetStartedPage) is injected here
                    ),
                  ),
                ),
              );
            },
          ),
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
