import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_system/src/components/preview/ds_preview_scaffold.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

/// Semantic sizes for DS social button variants.
enum DSSocialButtonSize { medium }

/// A customizable social login button
enum DSSocialButtonType { google, facebook, apple, twitter }

class _DSSocialButtonSizeSpec {
  const _DSSocialButtonSizeSpec({
    required this.gap,
    required this.height,
    required this.iconSize,
    required this.labelStyle,
    required this.radiusSize,
  });

  final double gap;
  final double height;
  final double iconSize;
  final TextStyle labelStyle;
  final double radiusSize;
}

class _DSSocialButtonTypeSpec {
  const _DSSocialButtonTypeSpec({
    required this.label,
    required this.icon,
    required this.borderSide,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.disabledForegroundColor,
    required this.disabledBackgroundColor,
  });

  /// Label text for the button
  final String label;

  /// Icon asset path for the button
  final String icon;

  /// Foreground color for the button
  final Color foregroundColor;

  /// Background color for the button
  final Color backgroundColor;

  /// Disabled foreground color for the button
  final Color disabledForegroundColor;

  /// Disabled background color for the button
  final Color disabledBackgroundColor;

  /// Border side for the button
  final BorderSide borderSide;
}

extension on DSSocialButtonSize {
  _DSSocialButtonSizeSpec get spec {
    switch (this) {
      case DSSocialButtonSize.medium:
        return _DSSocialButtonSizeSpec(
          gap: SpacingTokens.spacing12,
          height: Sizes.size48,
          iconSize: Sizes.size20,
          radiusSize: RadiusTokens.full,
          labelStyle: TypographyTokens.bodyMedium,
        );
    }
  }
}

/// A customizable social login button that supports multiple platforms like Google, Facebook, Apple, and Twitter.
extension on DSSocialButtonType {
  _DSSocialButtonTypeSpec spec(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final border = isDark
        ? SemanticColorsDark.border
        : SemanticColorsLight.border;

    final foregroundColor = isDark
        ? SemanticColorsDark.buttonForegroundColor
        : SemanticColorsLight.buttonForegroundColor;

    final backgroundColor = isDark
        ? SemanticColorsDark.buttonBackgroundColor
        : SemanticColorsLight.buttonBackgroundColor;

    switch (this) {
      case DSSocialButtonType.google:
        return _DSSocialButtonTypeSpec(
          label: 'Sign in with Google',
          icon: 'assets/icons/google.svg',
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          borderSide: isDark ? BorderSide.none : BorderSide(color: border),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.38),
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.38),
        );
      case DSSocialButtonType.facebook:
        return _DSSocialButtonTypeSpec(
          label: 'Sign in with Facebook',
          icon: 'assets/icons/facebook.svg',
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          borderSide: isDark ? BorderSide.none : BorderSide(color: border),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.38),
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.38),
        );
      case DSSocialButtonType.twitter:
        return _DSSocialButtonTypeSpec(
          label: 'Sign in with Twitter',
          icon: 'assets/icons/twitter.svg',
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          borderSide: isDark ? BorderSide.none : BorderSide(color: border),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.38),
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.38),
        );
      case DSSocialButtonType.apple:
        return _DSSocialButtonTypeSpec(
          label: 'Sign in with Apple',
          icon: 'assets/icons/apple.svg',
          foregroundColor: foregroundColor,
          borderSide: isDark ? BorderSide.none : BorderSide(color: border),
          backgroundColor: backgroundColor,
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.38),
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.38),
        );
    }
  }
}

class DSSocialButton extends StatelessWidget {
  const DSSocialButton({
    super.key,
    required this.type,
    this.label,
    this.width,
    this.height,
    this.onPressed,
    this.isDisabled = false,
    this.size = DSSocialButtonSize.medium,
    this.iconAlignment = IconAlignment.start,
  });

  /// Label text for the button
  final String? label;

  /// Type of social button (Google, Facebook, Apple, Twitter)
  final DSSocialButtonType type;

  /// Semantic size of the button
  final DSSocialButtonSize size;

  /// Callback function when the button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Alignment of the icon relative to the label
  final IconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final sizeSpec = size.spec;
    final typeSpec = type.spec(context.dsTheme.brightness);
    final resolvedHeight = height ?? sizeSpec.height;
    final resolvedWidth = width ?? double.infinity;

    return SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: OutlinedButton.icon(
        onPressed: isDisabled ? null : onPressed,
        icon: DSIconAsset(
          assetName: typeSpec.icon,
          width: sizeSpec.iconSize,
          height: sizeSpec.iconSize,
        ),
        label: Text(label ?? typeSpec.label),
        iconAlignment: iconAlignment,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(resolvedWidth, resolvedHeight),
          backgroundColor: isDisabled
              ? typeSpec.disabledBackgroundColor
              : typeSpec.backgroundColor,
          foregroundColor: isDisabled
              ? typeSpec.disabledForegroundColor
              : typeSpec.foregroundColor,
          side: typeSpec.borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizeSpec.radiusSize),
          ),
          textStyle: sizeSpec.labelStyle,
        ),
      ),
    );
  }
}

@Preview(name: 'DSSocialButton Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSSocialButton Preview - Dark', brightness: Brightness.dark)
Widget socialButtonLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSSocialButton(
            type: DSSocialButtonType.google,
            onPressed: () {},
            width: 229.0,
          ),
          DSSocialButton(
            type: DSSocialButtonType.facebook,
            onPressed: () {},
            width: 229.0,
          ),
          DSSocialButton(
            type: DSSocialButtonType.twitter,
            onPressed: () {},
            width: 229.0,
          ),
          DSSocialButton(
            type: DSSocialButtonType.apple,
            onPressed: () {},
            width: 229.0,
          ),
        ],
      ),
    ],
  );
}
