import 'package:flutter/material.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

/// Reusable shell for widget_previews to avoid repeating boilerplate.
class DsPreviewScaffold extends StatelessWidget {
  const DsPreviewScaffold({
    super.key,
    this.title,
    this.theme,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(24),
    this.spacing = SpacingTokens.spacing12,
    required this.children,
  });

  /// Optional title to show at the top of the preview canvas.
  final String? title;

  /// Theme used by [MaterialApp]. Defaults to [DSThemeLight].
  final ThemeData? theme;

  /// Background color for preview scaffold.
  final Color? backgroundColor;

  /// Outer content padding.
  final EdgeInsetsGeometry padding;

  /// Spacing between preview children.
  final double spacing;

  /// Widgets displayed in the preview.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final previewTheme = theme ?? DSThemeLight.build();

    return MaterialApp(
      theme: previewTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: padding,
            child: Column(
              spacing: spacing,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(title!, style: TypographyTokens.headlineSmall),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
