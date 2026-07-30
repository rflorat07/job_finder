import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A custom toggle switch that follows the design system specification.
///
/// Track: 44x24 with a 12px radius and 2px inner padding.
/// Thumb: 20x20 white circle with a subtle drop shadow.
/// Active track uses the brand [primary] color, while the inactive track
/// uses the greyscale surface color.
class DSSwitch extends StatelessWidget {
  const DSSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
  });

  /// Whether the switch is on.
  final bool value;

  /// Callback invoked with the new value when tapped.
  ///
  /// When `null`, the switch is rendered as disabled and does not respond
  /// to taps.
  final ValueChanged<bool>? onChanged;

  /// Track color when [value] is `true`. Defaults to the brand primary color.
  final Color? activeTrackColor;

  /// Track color when [value] is `false`. Defaults to the greyscale surface.
  final Color? inactiveTrackColor;

  /// Thumb color. Defaults to white.
  final Color? thumbColor;

  // Dimensions from the design specification.
  static const double _trackWidth = SizesTokens.size44;
  static const double _trackHeight = SizesTokens.size24;
  static const double _thumbSize = SizesTokens.size20;
  static const double _padding = SizesTokens.size2;

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final bool enabled = onChanged != null;
    final bool isDark = colors.brightness == Brightness.dark;

    final Color activeColor = activeTrackColor ?? colors.primary;
    // Inactive track follows the theme: greyscale50 in light, greyscale700 in dark.
    final Color inactiveColor =
        inactiveTrackColor ??
        Color(
          isDark ? PrimitiveColors.greyscale700 : PrimitiveColors.greyscale50,
        );

    final Color trackColor = value ? activeColor : inactiveColor;
    final Color resolvedThumbColor = thumbColor ?? Colors.white;

    return Semantics(
      container: true,
      toggled: value,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => onChanged!(!value) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: _trackWidth,
            height: _trackHeight,
            padding: const EdgeInsets.all(_padding),
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: RadiusTokens.mdRadius,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: BoxDecoration(
                  color: resolvedThumbColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A101828),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Color(0x0F101828),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSSwitch Preview - Light', brightness: Brightness.light)
Widget dsSwitchLightPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSSwitch(value: true, onChanged: (_) {}),
          DSSwitch(value: false, onChanged: (_) {}),
          const DSSwitch(value: true, onChanged: null),
          const DSSwitch(value: false, onChanged: null),
        ],
      ),
    ],
  );
}
