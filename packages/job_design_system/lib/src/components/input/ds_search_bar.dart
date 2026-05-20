import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A tappable search bar that acts as a navigation trigger
/// (does NOT contain a real text field — purely visual).
///
/// Common pattern in apps like Google, Airbnb, and LinkedIn
/// where tapping the bar navigates to a dedicated search screen.
class DSSearchBar extends StatelessWidget {
  /// Placeholder text displayed in the bar.
  final String hintText;

  /// Callback when the user taps the search bar.
  final VoidCallback? onTap;

  /// Leading icon displayed before the hint text.
  final IconData icon;

  /// Color of the hint text and leading icon.
  final Color? hintColor;

  /// Background color of the search bar.
  final Color? backgroundColor;

  /// Border radius of the search bar.
  final BorderRadius borderRadius;

  /// Internal padding of the search bar.
  final EdgeInsetsGeometry padding;

  const DSSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
    this.icon = Icons.search,
    this.hintColor,
    this.backgroundColor,
    this.borderRadius = RadiusTokens.fullRadius,
    this.padding = const EdgeInsets.symmetric(
      horizontal: SpacingTokens.spacing16,
      vertical: SpacingTokens.spacing14,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHintColor = hintColor ?? context.dsColors.secondary;

    return Semantics(
      button: true,
      label: hintText,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? context.dsColors.primaryContainer,
            borderRadius: borderRadius,
          ),
          child: Row(
            spacing: SpacingTokens.spacing16,
            children: [
              Icon(icon, color: effectiveHintColor, size: SizesTokens.size24),
              Expanded(
                child: Text(
                  hintText,
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    color: effectiveHintColor,
                    height: TypographyTokens.lineHeightExtraRelaxed,
                    fontWeight: TypographyTokens.fontWeightRegular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSSearchBar Preview - Light', brightness: Brightness.light)
Widget dsSearchBarLightPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      DSSearchBar(hintText: 'Ex. Product Designer'),
      DSSearchBar(hintText: 'Search jobs, companies...'),
    ],
  );
}
