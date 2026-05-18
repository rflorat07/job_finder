import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/src/components/preview/ds_preview_scaffold.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

/// Semantic sizes for DS button variants.
enum DSButtonSize { xsmall, small, medium, large }

/// Semantic states for DS button variants.
enum DSButtonState { primary, hover, focused, disabled }

/// Visual style variants for DS buttons.
enum DSButtonType { primary, secondary, tertiary, destructive }

class _DSButtonSizeSpec {
  const _DSButtonSizeSpec({
    required this.gap,
    this.width,
    required this.height,
    required this.iconSize,
    required this.labelStyle,
    required this.radiusSize,
  });

  final double gap;
  final double height;
  final double? width;
  final double iconSize;
  final TextStyle labelStyle;
  final double radiusSize;
}

class _DSButtonTypeSpec {
  const _DSButtonTypeSpec({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.hoverBackgroundColor,
    required this.hoverForegroundColor,
    required this.disabledForegroundColor,
    required this.disabledBackgroundColor,
    required this.focusedBackgroundColor,
    required this.focusedForegroundColor,
    this.focusedBorderSide,
    this.defaultBorderSide,
    this.disabledBorderSide,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color hoverBackgroundColor;
  final Color hoverForegroundColor;
  final BorderSide? focusedBorderSide;
  final Color focusedForegroundColor;
  final Color focusedBackgroundColor;
  final Color disabledForegroundColor;
  final Color disabledBackgroundColor;
  final BorderSide? defaultBorderSide;
  final BorderSide? disabledBorderSide;
}

extension on DSButtonSize {
  _DSButtonSizeSpec get spec {
    switch (this) {
      case DSButtonSize.xsmall:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: SizesTokens.size32,
          //width: double.infinity,
          iconSize: SizesTokens.size16,
          labelStyle: TypographyTokens.bodyXSmall,
          radiusSize: RadiusTokens.full, // Pill shape
        );
      case DSButtonSize.small:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: SizesTokens.size40,
          //width: double.infinity,
          iconSize: SizesTokens.size16,
          labelStyle: TypographyTokens.bodySmall,
          radiusSize: RadiusTokens.full,
        );
      case DSButtonSize.medium:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: SizesTokens.size48,
          //width: double.infinity,
          iconSize: SizesTokens.size20,
          labelStyle: TypographyTokens.bodyMedium,
          radiusSize: RadiusTokens.full,
        );
      case DSButtonSize.large:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: SizesTokens.size52,
          //width: double.infinity,
          iconSize: SizesTokens.size20,
          labelStyle: TypographyTokens.bodyMedium,
          radiusSize: RadiusTokens.full,
        );
    }
  }
}

extension on DSButtonType {
  _DSButtonTypeSpec spec(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Type primary
    final primaryBackgroundColor = isDark
        ? SemanticColorsDark.defaultButtonBackgroundColor
        : SemanticColorsLight.defaultButtonBackgroundColor;

    final primaryForegroundColor = isDark
        ? SemanticColorsDark.primary
        : SemanticColorsLight.primary;

    final primaryDisabledBackgroundColor = isDark
        ? SemanticColorsDark.primaryDisabled
        : SemanticColorsLight.primaryDisabled;

    final primaryDisabledForegroundColor = isDark
        ? SemanticColorsDark.textDisabled
        : SemanticColorsLight.textDisabled;

    final hoverBackgroundColor = isDark
        ? SemanticColorsDark.primaryHover
        : SemanticColorsLight.primaryHover;

    final hoverForegroundColor = isDark
        ? SemanticColorsDark.textPrimary
        : SemanticColorsLight.textDisabled;

    // Type secondary
    final secondaryBackgroundColor = isDark
        ? SemanticColorsDark.secondary
        : SemanticColorsLight.buttonBackgroundColor;

    final secondaryForegroundColor = isDark
        ? SemanticColorsDark.textPrimary
        : SemanticColorsLight.buttonForegroundColor;

    final secondaryHoverBackgroundColor = isDark
        ? SemanticColorsDark.secondaryHover
        : SemanticColorsLight.secondaryHover;

    final secondaryHoverForegroundColor = isDark
        ? SemanticColorsDark.textPrimary
        : SemanticColorsLight.buttonForegroundColor;

    final secondaryDefaultBorderSide = isDark
        ? SemanticColorsDark.border
        : SemanticColorsLight.border;

    final secondaryDisabledBackgroundColor = isDark
        ? SemanticColorsDark.secondaryDisabledBackground
        : SemanticColorsLight.secondaryDisabledBackground;

    final secondaryDisabledForegroundColor = isDark
        ? SemanticColorsDark.textSecondaryDisabled
        : SemanticColorsLight.textSecondaryDisabled;

    // Type destructive
    final destructiveBackgroundColor = isDark
        ? SemanticColorsDark.error
        : SemanticColorsLight.error;

    final destructiveForegroundColor = isDark
        ? SemanticColorsDark.textPrimary
        : SemanticColorsLight.textOnInverse;

    final destructiveHoverBackgroundColor = isDark
        ? SemanticColorsDark.errorHover
        : SemanticColorsLight.errorHover;

    final destructiveHoverForegroundColor = isDark
        ? SemanticColorsDark.textPrimary
        : SemanticColorsLight.textOnInverse;

    final destructiveDisabledBackgroundColor = isDark
        ? SemanticColorsDark.errorDisabled
        : SemanticColorsLight.errorDisabled;

    final destructiveDisabledForegroundColor = isDark
        ? SemanticColorsDark.textDisabled
        : SemanticColorsLight.textDisabled;

    switch (this) {
      case DSButtonType.primary:
        return _DSButtonTypeSpec(
          // State standard
          foregroundColor: primaryForegroundColor,
          backgroundColor: primaryBackgroundColor,

          // State hover
          hoverForegroundColor: hoverForegroundColor,
          hoverBackgroundColor: hoverBackgroundColor,

          // State focused
          focusedForegroundColor: hoverForegroundColor,
          focusedBackgroundColor: hoverBackgroundColor,
          focusedBorderSide: BorderSide(
            color: primaryBackgroundColor,
            width: 3,
          ),

          // State disabled
          disabledForegroundColor: primaryDisabledForegroundColor,
          disabledBackgroundColor: primaryDisabledBackgroundColor,
        );

      case DSButtonType.secondary:
        return _DSButtonTypeSpec(
          // State standard
          foregroundColor: secondaryForegroundColor,
          backgroundColor: secondaryBackgroundColor,
          defaultBorderSide: BorderSide(color: secondaryDefaultBorderSide),

          // State hover
          hoverForegroundColor: secondaryHoverForegroundColor,
          hoverBackgroundColor: secondaryHoverBackgroundColor,

          // State focused
          focusedForegroundColor: secondaryForegroundColor,
          focusedBackgroundColor: secondaryBackgroundColor,
          focusedBorderSide: BorderSide(
            color: primaryBackgroundColor,
            width: 3,
          ),

          // State disabled
          disabledForegroundColor: secondaryDisabledForegroundColor,
          disabledBackgroundColor: secondaryDisabledBackgroundColor,
          disabledBorderSide: BorderSide(
            color: secondaryDisabledForegroundColor,
          ),
        );

      case DSButtonType.tertiary:
        return _DSButtonTypeSpec(
          // State standard
          foregroundColor: secondaryForegroundColor,
          backgroundColor: secondaryBackgroundColor,

          // State hover
          hoverBackgroundColor: secondaryHoverBackgroundColor,
          hoverForegroundColor: secondaryHoverForegroundColor,

          // State focused
          focusedForegroundColor: secondaryHoverForegroundColor,
          focusedBackgroundColor: secondaryHoverBackgroundColor,

          // State disabled
          disabledForegroundColor: secondaryDisabledForegroundColor,
          disabledBackgroundColor: secondaryDisabledBackgroundColor,
        );

      case DSButtonType.destructive:
        return _DSButtonTypeSpec(
          // State standard
          foregroundColor: destructiveForegroundColor,
          backgroundColor: destructiveBackgroundColor,

          // State hover
          hoverBackgroundColor: destructiveHoverBackgroundColor,
          hoverForegroundColor: destructiveHoverForegroundColor,

          // State focused
          focusedForegroundColor: destructiveForegroundColor,
          focusedBackgroundColor: destructiveBackgroundColor,
          focusedBorderSide: BorderSide(
            color: primaryBackgroundColor,
            width: 3,
          ),

          // State disabled
          disabledForegroundColor: destructiveDisabledForegroundColor,
          disabledBackgroundColor: destructiveDisabledBackgroundColor,
        );
    }
  }
}

/// Primary elevated button component that consumes design system tokens.
/// No hardcoded values - all styling from tokens.
class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    this.icon,
    this.label,
    this.width,
    this.height,
    this.onPressed,
    this.iconAlignment,
    this.iconOnly = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = DSButtonSize.large,
    this.type = DSButtonType.primary,
    this.state = DSButtonState.hover,
  }) : assert(
         !iconOnly || (icon != null),
         'Icon must be provided when iconOnly is true',
       );

  /// Label text for the button
  final String? label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Semantic size of the button
  final DSButtonSize size;

  /// Visual style variant of the button
  final DSButtonType type;

  /// Visual style variant of the button
  final DSButtonState state;

  /// Optional custom width
  final double? width;

  /// Optional custom height
  final double? height;

  /// Whether the button should be rendered as an icon-only
  final bool iconOnly;

  /// Optional icon to display when [iconOnly] is true
  final Widget? icon;

  /// Optional alignment for the icon when [iconOnly] is true
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    final stateSpec = state;
    final sizeSpec = size.spec;
    final typeSpec = type.spec(context.dsTheme.brightness);
    final resolvedHeight = height ?? sizeSpec.height;
    final resolvedWidth = iconOnly ? sizeSpec.height : width ?? sizeSpec.width;

    final loadingIndicator = SizedBox(
      width: SpacingTokens.spacing16,
      height: SpacingTokens.spacing16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(typeSpec.disabledForegroundColor),
      ),
    );

    final buttonStyle = ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),

      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return typeSpec.disabledBackgroundColor;
        }

        switch (stateSpec) {
          case DSButtonState.primary:
            return typeSpec.backgroundColor;
          case DSButtonState.hover:
            return typeSpec.hoverBackgroundColor;
          case DSButtonState.focused:
            return typeSpec.focusedBackgroundColor;
          case DSButtonState.disabled:
            return typeSpec.disabledBackgroundColor;
        }
      }),

      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return typeSpec.disabledForegroundColor;
        }

        switch (stateSpec) {
          case DSButtonState.primary:
            return typeSpec.foregroundColor;
          case DSButtonState.hover:
            return typeSpec.hoverForegroundColor;
          case DSButtonState.focused:
            return typeSpec.focusedForegroundColor;
          case DSButtonState.disabled:
            return typeSpec.disabledForegroundColor;
        }
      }),

      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return typeSpec.disabledBorderSide ?? BorderSide.none;
        }

        return typeSpec.defaultBorderSide ?? BorderSide.none;
      }),

      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: SpacingTokens.spacing16),
      ),

      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeSpec.radiusSize),
        ),
      ),
    );

    return SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: iconOnly
          ? IconButton.filled(
              tooltip: label,
              onPressed: isDisabled || isLoading ? null : onPressed,
              icon: isLoading ? loadingIndicator : icon!,
              style: buttonStyle.copyWith(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              ),
            )
          : icon != null
          ? FilledButton.icon(
              onPressed: isDisabled || isLoading ? null : onPressed,
              iconAlignment: iconAlignment,
              icon: isLoading ? loadingIndicator : icon!,
              label: isLoading
                  ? SizedBox.shrink()
                  : Text(label ?? '', style: sizeSpec.labelStyle),
              style: buttonStyle,
            )
          : FilledButton(
              onPressed: isDisabled || isLoading ? null : onPressed,
              style: buttonStyle,
              child: isLoading
                  ? loadingIndicator
                  : Text(label ?? '', style: sizeSpec.labelStyle),
            ),
    );
  }
}

@Preview(name: 'DSButton Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSButton Preview - Dark', brightness: Brightness.dark)
Widget buttonLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      DSButton(
        label: 'Button',
        onPressed: () {},
        icon: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      DSButton(
        label: 'Button',
        onPressed: () {},
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        type: DSButtonType.secondary,
      ),
      DSButton(
        label: 'Button',
        onPressed: () {},
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        type: DSButtonType.tertiary,
      ),
      DSButton(
        label: 'Button',
        onPressed: () {},
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        type: DSButtonType.destructive,
      ),

      Row(
        spacing: SpacingTokens.spacing12,
        children: [
          DSButton(
            onPressed: () {},
            iconOnly: true,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: SizesTokens.size20,
            ),
          ),
          DSButton(
            onPressed: () {},
            iconOnly: true,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: SizesTokens.size20,
            ),
            type: DSButtonType.secondary,
          ),
          DSButton(
            onPressed: () {},
            iconOnly: true,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: SizesTokens.size20,
            ),
            type: DSButtonType.tertiary,
          ),
          DSButton(
            onPressed: () {},
            iconOnly: true,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: SizesTokens.size20,
            ),
            type: DSButtonType.destructive,
          ),
        ],
      ),
    ],
  );
}
