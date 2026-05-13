import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSAuthTabBarBaseLayout extends StatelessWidget {
  const DSAuthTabBarBaseLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tabs,
    required this.tabViews,
    this.containerColor,
    this.backgroundColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
  }) : assert(
         tabs.length == tabViews.length,
         'tabs and tabViews must have the same length',
       );

  /// Base layout title
  final String title;

  /// Base layout title text style
  final TextStyle? titleTextStyle;

  /// Base layout subtitle
  final String subtitle;

  /// Base layout subtitle text style
  final TextStyle? subtitleTextStyle;

  /// List of tab widgets (usually [Tab])
  final List<Widget> tabs;

  /// List of view widgets for each tab
  final List<Widget> tabViews;

  /// Base layout background color
  final Color? backgroundColor;

  /// Base layout container color
  final Color? containerColor;

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
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AuthHeader(
                  title: title,
                  subtitle: subtitle,
                  titleTextStyle: titleTextStyle,
                  subtitleTextStyle: subtitleTextStyle,
                ),
                _AuthTabContainer(
                  tabs: tabs,
                  containerColor: containerColor,
                  tabViews: tabViews,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusing the private header from the other layout
class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
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
    return Padding(
      padding: const EdgeInsets.symmetric(
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
    );
  }
}

// New private widget for the tab container
class _AuthTabContainer extends StatelessWidget {
  const _AuthTabContainer({
    required this.tabs,
    required this.containerColor,
    required this.tabViews,
  });

  final Color? containerColor;
  final List<Widget> tabs;
  final List<Widget> tabViews;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: containerColor ?? context.dsColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(SizesTokens.size24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(SizesTokens.size24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              SpacingTokens.spacing24,
              SpacingTokens.spacing32,
              SpacingTokens.spacing24,
              SpacingTokens.spacing2,
            ),
            child: Column(
              children: [
                // TabBar
                TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  tabs: tabs,
                ),
                // Content of the Tabs
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: tabViews,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSAuthTabBarBaseLayout Preview', brightness: Brightness.light)
Widget dsAuthTabBarBaseLayoutPreview() {
  return DSAuthTabBarBaseLayout(
    backgroundColor: Colors.green,
    title: 'Welcome',
    subtitle: 'Please login or register to continue.',
    tabs: const [
      Tab(text: 'Login'),
      Tab(text: 'Register'),
    ],
    tabViews: const [
      Center(child: Text('Login Form Content')),
      Center(child: Text('Register Form Content')),
    ],
  );
}
