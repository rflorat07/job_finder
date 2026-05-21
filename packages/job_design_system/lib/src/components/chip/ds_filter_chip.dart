import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSFilterChip extends StatelessWidget {
  const DSFilterChip({
    super.key,
    required this.label,
    this.onSelected,
    this.isSelected,
    this.showCheckmark = false,
  });

  /// The text label of the chip.
  final String label;

  /// Whether the chip is currently selected.
  final bool? isSelected;

  /// Whether to show the checkmark.
  final bool showCheckmark;

  /// Callback when the chip is tapped. Provides the new selected state.
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = isSelected ?? false;
    final colorScheme = context.dsColors;

    // Si queremos el color claro verde usamos una opacidad sobre el primary.
    // O si en tokens hay un surface success/primary, lo usamos.
    final bgColor = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.secondaryContainer;

    final textColor = selected ? colorScheme.primary : colorScheme.secondary;

    final borderColor = selected
        ? colorScheme.primary
        : colorScheme.secondaryContainer;

    return GestureDetector(
      onTap: () => onSelected?.call(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing24,
          vertical: SpacingTokens.spacing8,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: RadiusTokens.fullRadius,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          label,
          style: context.dsTextTheme.bodySmall?.copyWith(
            color: textColor,
            height: TypographyTokens.lineHeightExtraRelaxed,
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSFilterChip Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSFilterChip Preview - Dark', brightness: Brightness.dark)
Widget dsFilterChipLightDarkPreview() {
  return DsPreviewScaffold(
    backgroundColor: Color(PrimitiveColors.greyscale25),
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSFilterChip(
            onSelected: (bool selected) {},
            isSelected: false,
            label: 'Accounting',
          ),

          DSFilterChip(
            onSelected: (bool selected) {},
            isSelected: true,
            label: 'Accounting',
          ),
        ],
      ),
    ],
  );
}
