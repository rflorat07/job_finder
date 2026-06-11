import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import 'ds_system_ui_style.dart';

/// A flexible base layout for screens with a colored header and white content area.
///
/// Combines a customizable header (top colored section) with a scrollable/flexible
/// white container (bottom section). Perfect for auth flows, onboarding, or any
/// screen with a two-zone visual hierarchy.
///
/// The layout automatically handles:
/// - Status bar styling
/// - SafeArea padding
/// - Rounded corners on the content container
/// - Flexible header that you customize entirely
class DSBaseLayout extends StatelessWidget {
  /// Creates a [DSBaseLayout].
  const DSBaseLayout({
    super.key,
    this.header,
    required this.child,
    this.containerColor,
    this.backgroundColor,
    this.containerPadding,
    this.systemUiStyle = DSSystemUiStyle.light,
  });

  /// Custom header widget to display above the content container.
  ///
  /// If null, no header is rendered and the content takes the full screen.
  /// You have full control over what appears here (title, subtitle, back button, etc).
  /// Example: A Column with title + subtitle, or just a back button.
  final Widget? header;

  /// The main content widget inside the white/colored container.
  ///
  /// This widget controls its own scrolling behavior:
  /// - Simple column? Use a regular [Column] — [Spacer] works natively.
  /// - Lots of content? Wrap in [SingleChildScrollView] or [ListView].
  /// - Custom layout? Use [CustomScrollView] with slivers.
  final Widget child;

  /// Background color of the container (the white zone).
  ///
  /// Defaults to [DSColors.tertiaryContainer] from the design system.
  /// Use this to match your brand theme or override for specific screens.
  final Color? containerColor;

  /// Background color of the header area (the colored zone behind the header).
  ///
  /// Defaults to [DSColors.primary] from the design system.
  /// Typically a vibrant brand color that contrasts with the container.
  final Color? backgroundColor;

  /// Padding inside the content container.
  ///
  /// Defaults to:
  /// - Horizontal: [SpacingTokens.spacing24]
  /// - Vertical: [SpacingTokens.spacing32]
  ///
  /// Set to [EdgeInsets.zero] if your child manages its own padding
  /// (e.g., inside a [SingleChildScrollView]).
  final EdgeInsetsGeometry? containerPadding;

  /// Status bar icon style for the current screen.
  ///
  /// Use [DSSystemUiStyle.light] for white status bar icons
  /// (dark header background), or [DSSystemUiStyle.dark] for dark icons
  /// (light header background).
  final DSSystemUiStyle systemUiStyle;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dsSystemUiOverlayStyle(systemUiStyle),
      child: Scaffold(
        backgroundColor: backgroundColor ?? context.dsColors.primary,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header zone (optional, colored background)
              ?header,

              // Content zone (expandable, white container with rounded top)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(SizesTokens.size24),
                  ),
                  child: ColoredBox(
                    color: containerColor ?? context.dsColors.tertiaryContainer,
                    child: Padding(
                      padding:
                          containerPadding ??
                          const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.spacing24,
                            vertical: SpacingTokens.spacing32,
                          ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(
  name: 'DSBaseLayout Preview - Fixed Content',
  brightness: Brightness.light,
)
Widget dsBaseLayoutFixedContentPreview() {
  return DSBaseLayout(
    backgroundColor: Colors.green,
    containerColor: Colors.white,
    header: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
        vertical: SpacingTokens.spacing20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.spacing8),
          const Text(
            'Sign in to continue exploring',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SpacingTokens.spacing24,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text('Email Field')),
        ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text('Password Field')),
        ),
        const Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

@Preview(
  name: 'DSBaseLayout Preview - Scrollable Content',
  brightness: Brightness.light,
)
Widget dsBaseLayoutScrollableContentPreview() {
  return DSBaseLayout(
    backgroundColor: Colors.blue,
    containerColor: Colors.white,
    containerPadding: EdgeInsets.zero,
    header: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
        vertical: SpacingTokens.spacing20,
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
        vertical: SpacingTokens.spacing32,
      ),
      child: Column(
        spacing: SpacingTokens.spacing16,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Field 1')),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Field 2')),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Field 3')),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Field 4')),
          ),
          const SizedBox(height: SpacingTokens.spacing24),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'DSBaseLayout Preview - No Header', brightness: Brightness.light)
Widget dsBaseLayoutNoHeaderPreview() {
  return DSBaseLayout(
    backgroundColor: Colors.purple,
    containerColor: Colors.white,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Content Zone',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: SpacingTokens.spacing16),
          const Text(
            'No header, full content area',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
