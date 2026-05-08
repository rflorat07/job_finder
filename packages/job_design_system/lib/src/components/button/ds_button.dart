import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/src/components/preview/ds_preview_scaffold.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

/// Semantic sizes for DS button variants.
enum DSButtonSize { xsmall, small, medium, large }

enum DSButtonType { primary, secondary, tertiary, destructive, back }

class _DSButtonSizeSpec {
  const _DSButtonSizeSpec({
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

class _DSButtonTypeSpec {
  const _DSButtonTypeSpec({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.disabledForegroundColor,
    required this.disabledBackgroundColor,
    this.borderSide,
    this.disabledBorderSide,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color disabledForegroundColor;
  final Color disabledBackgroundColor;
  final BorderSide? borderSide;
  final BorderSide? disabledBorderSide;
}

extension on DSButtonSize {
  _DSButtonSizeSpec get spec {
    switch (this) {
      case DSButtonSize.xsmall:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: Sizes.size32,
          iconSize: Sizes.size16,
          labelStyle: TypographyTokens.bodyXSmall,
          radiusSize: RadiusTokens.full, // Pill shape
        );
      case DSButtonSize.small:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: Sizes.size40,
          iconSize: Sizes.size16,
          labelStyle: TypographyTokens.bodySmall,
          radiusSize: RadiusTokens.full,
        );
      case DSButtonSize.medium:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: Sizes.size48,
          iconSize: Sizes.size20,
          labelStyle: TypographyTokens.bodyMedium,
          radiusSize: RadiusTokens.full,
        );
      case DSButtonSize.large:
        return _DSButtonSizeSpec(
          gap: SpacingTokens.buttonGap,
          height: Sizes.size52,
          iconSize: Sizes.size20,
          labelStyle: TypographyTokens.bodyMedium,
          radiusSize: RadiusTokens.full,
        );
    }
  }
}

extension on DSButtonType {
  _DSButtonTypeSpec spec(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final textPrimary = isDark
        ? SemanticColorsDark.textPrimary
        : SemanticColorsLight.textPrimary;
    final textOnInverse = isDark
        ? SemanticColorsDark.textOnInverse
        : SemanticColorsLight.textOnInverse;
    final textDisabled = isDark
        ? SemanticColorsDark.textDisabled
        : SemanticColorsLight.textDisabled;
    final textSecondaryDisabled = isDark
        ? SemanticColorsDark.textSecondaryDisabled
        : SemanticColorsLight.textSecondaryDisabled;
    final primary = isDark
        ? SemanticColorsDark.primary
        : SemanticColorsLight.primary;
    final primaryDisabled = isDark
        ? SemanticColorsDark.primaryDisabled
        : SemanticColorsLight.primaryDisabled;
    final secondary = isDark
        ? SemanticColorsDark.secondary
        : SemanticColorsLight.secondary;
    final secondaryDisabled = isDark
        ? SemanticColorsDark.secondary
        : SemanticColorsLight.secondary;
    final border = isDark
        ? SemanticColorsDark.border
        : SemanticColorsLight.border;
    final error = isDark ? SemanticColorsDark.error : SemanticColorsLight.error;

    switch (this) {
      case DSButtonType.primary:
        return _DSButtonTypeSpec(
          foregroundColor: textOnInverse,
          backgroundColor: primary,
          disabledForegroundColor: textDisabled,
          disabledBackgroundColor: primaryDisabled,
        );
      case DSButtonType.secondary:
        return _DSButtonTypeSpec(
          foregroundColor: textPrimary,
          backgroundColor: secondary,
          disabledForegroundColor: textSecondaryDisabled,
          disabledBackgroundColor: secondaryDisabled,
          borderSide: BorderSide(color: border),
          disabledBorderSide: BorderSide(color: border),
        );
      case DSButtonType.tertiary:
        return _DSButtonTypeSpec(
          foregroundColor: primary,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: textDisabled,
          disabledBackgroundColor: Colors.transparent,
        );
      case DSButtonType.destructive:
        return _DSButtonTypeSpec(
          foregroundColor: textOnInverse,
          backgroundColor: error,
          disabledForegroundColor: textDisabled,
          disabledBackgroundColor: primaryDisabled,
        );
      case DSButtonType.back:
        return _DSButtonTypeSpec(
          foregroundColor: textOnInverse,
          backgroundColor: SemanticColorsDark.backButtonBackgroundColor,
          disabledForegroundColor: textDisabled,
          disabledBackgroundColor: primaryDisabled,
        );
    }
  }
}

/// Primary elevated button component that consumes design system tokens.
/// No hardcoded values - all styling from tokens.
class DSButton extends StatelessWidget {
  /// Label text for the button
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Optional icon to display at the start of the label
  final IconData? iconLeft;

  /// Optional icon to display at the end of the label
  final IconData? iconRight;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Semantic size of the button
  final DSButtonSize size;

  /// Visual style variant of the button
  final DSButtonType type;

  /// Optional custom width
  final double? width;

  /// Optional custom height
  final double? height;

  /// Whether the button should be rendered as an icon-only button (circular)
  final bool iconOnly;

  const DSButton({
    super.key,
    required this.label,
    this.height,
    this.onPressed,
    this.iconLeft,
    this.iconRight,
    this.iconOnly = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.width = double.infinity,
    this.size = DSButtonSize.large,
    this.type = DSButtonType.primary,
  }) : assert(
         !iconOnly || iconLeft != null || iconRight != null || isLoading,
         'iconOnly requires iconLeft or iconRight unless loading',
       ),
       assert(
         !iconOnly || iconLeft == null || iconRight == null,
         'iconOnly supports a single icon. Pass iconLeft or iconRight, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spec = size.spec;
    final typeSpec = type.spec(theme.brightness);
    final loaderColor = typeSpec.foregroundColor;
    final isIconOnly = iconOnly;
    final resolvedHeight = height ?? spec.height;
    final resolvedWidth = isIconOnly ? spec.height : width;
    final iconOnlyData = iconLeft ?? iconRight;
    final hasLeftIcon = iconLeft != null && !isLoading;
    final hasRightIcon = iconRight != null && !isLoading;
    final sideSlotWidth = spec.iconSize + spec.gap;

    final loadingIndicator = SizedBox(
      width: SpacingTokens.spacing16,
      height: SpacingTokens.spacing16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(loaderColor),
      ),
    );

    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasLeftIcon) ...[
          Icon(iconLeft, size: spec.iconSize),
          SizedBox(width: spec.gap),
        ] else if (hasRightIcon)
          SizedBox(width: sideSlotWidth),

        if (isLoading)
          loadingIndicator
        else
          Text(label, style: spec.labelStyle),

        if (hasRightIcon) ...[
          SizedBox(width: spec.gap),
          Icon(iconRight, size: spec.iconSize),
        ] else if (hasLeftIcon)
          SizedBox(width: sideSlotWidth),
      ],
    );

    final iconOnlyContent = isLoading
        ? loadingIndicator
        : Icon(iconOnlyData, size: spec.iconSize);

    final buttonStyle = ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return typeSpec.disabledBackgroundColor;
        }

        return typeSpec.backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return typeSpec.disabledForegroundColor;
        }

        return typeSpec.foregroundColor;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return typeSpec.disabledBorderSide ??
              typeSpec.borderSide ??
              BorderSide.none;
        }

        return typeSpec.borderSide ?? BorderSide.none;
      }),
      padding: WidgetStatePropertyAll(
        isIconOnly
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: SpacingTokens.spacing16),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spec.radiusSize),
        ),
      ),
    );

    return Container(
      width: resolvedWidth,
      height: resolvedHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(spec.radiusSize),
      ),
      child: FilledButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: buttonStyle,
        child: isIconOnly
            ? Semantics(
                button: true,
                enabled: !(isDisabled || isLoading),
                label: label,
                child: iconOnlyContent,
              )
            : buttonContent,
      ),
    );
  }
}

@Preview(name: 'DSButton Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSButton Preview - Dark', brightness: Brightness.dark)
Widget buttonLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Row(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSButton(
            label: 'Button',
            size: DSButtonSize.large,
            iconLeft: Icons.chevron_left,
            iconRight: Icons.chevron_right,
            onPressed: () {},
          ),

          DSButton(
            label: 'Button',
            size: DSButtonSize.medium,
            iconLeft: Icons.chevron_left,
            iconRight: Icons.chevron_right,
            isDisabled: true,
            onPressed: () {},
          ),

          DSButton(
            label: 'Delete',
            size: DSButtonSize.small,
            iconOnly: true,
            iconLeft: Icons.chevron_left,
            onPressed: () {},
          ),
        ],
      ),

      Row(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSButton(
            label: 'Button',
            size: DSButtonSize.large,
            type: DSButtonType.secondary,
            iconLeft: Icons.chevron_left,
            iconRight: Icons.chevron_right,
            onPressed: () {},
          ),

          DSButton(
            label: 'Button',
            size: DSButtonSize.large,
            type: DSButtonType.secondary,
            iconLeft: Icons.chevron_left,
            iconRight: Icons.chevron_right,
            isDisabled: true,
            onPressed: () {},
          ),

          DSButton(
            label: 'Delete',
            size: DSButtonSize.large,
            type: DSButtonType.secondary,
            iconOnly: true,
            iconLeft: Icons.chevron_left,
            onPressed: () {},
          ),
        ],
      ),
    ],
  );
}
