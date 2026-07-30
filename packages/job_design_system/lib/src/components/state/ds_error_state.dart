import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A reusable, centered error state with an icon, a message and an optional
/// retry action.
///
/// Use this anywhere a screen or section fails to load (network/server errors)
/// to keep the error UX consistent across the app.
class DSErrorState extends StatelessWidget {
  /// Primary message describing what went wrong.
  final String message;

  /// Optional emphasized title shown above the [message].
  final String? title;

  /// Icon rendered above the texts. Defaults to [Icons.error_outline].
  final IconData icon;

  /// Icon color. Defaults to the theme error color.
  final Color? iconColor;

  /// Icon size. Defaults to [SizesTokens.size48].
  final double iconSize;

  /// Label for the retry button. When `null`, the button is hidden.
  final String? retryLabel;

  /// Called when the retry button is pressed.
  final VoidCallback? onRetry;

  /// Outer padding around the content.
  final EdgeInsetsGeometry padding;

  const DSErrorState({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.error_outline,
    this.iconColor,
    this.iconSize = SizesTokens.size48,
    this.retryLabel,
    this.onRetry,
    this.padding = const EdgeInsets.all(SpacingTokens.spacing24),
  });

  @override
  Widget build(BuildContext context) {
    final showRetry = retryLabel != null && onRetry != null;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? context.dsColors.error,
            ),
            const SizedBox(height: SpacingTokens.spacing16),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: context.dsTextTheme.bodyLarge?.copyWith(
                  color: context.dsColors.onSurface,
                  fontWeight: TypographyTokens.fontWeightSemiBold,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing8),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.dsTextTheme.bodyMedium?.copyWith(
                color: context.dsColors.onSurfaceVariant,
              ),
            ),
            if (showRetry) ...[
              const SizedBox(height: SpacingTokens.spacing16),
              DSButton(label: retryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'DSErrorState Preview - Light', brightness: Brightness.light)
Widget dsErrorStatePreview() {
  return DsPreviewScaffold(
    children: [
      DSErrorState(
        title: 'Something went wrong',
        message: 'We could not load your profile. Please try again.',
        retryLabel: 'Try Again',
        onRetry: () {},
      ),
    ],
  );
}
