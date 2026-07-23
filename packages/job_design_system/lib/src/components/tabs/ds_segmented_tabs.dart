import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A pill-style segmented control used to switch between two or more views
/// (e.g. "Ongoing" / "History").
///
/// The selected segment is highlighted with the primary brand color while the
/// remaining segments stay transparent. Fully reusable across features.
class DSSegmentedTabs extends StatelessWidget {
  /// Labels rendered for each segment, in order.
  final List<String> labels;

  /// Index of the currently selected segment.
  final int selectedIndex;

  /// Callback invoked with the tapped segment index.
  final ValueChanged<int> onChanged;

  const DSSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  }) : assert(labels.length >= 2, 'Provide at least two segments');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.spacing6),
      decoration: BoxDecoration(
        color: context.dsColors.secondaryContainer,
        borderRadius: RadiusTokens.smRadius,
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: _Segment(
                label: labels[i],
                isSelected: i == selectedIndex,
                onTap: () => onChanged(i),
              ),
            ),
        ],
      ),
    );
  }
}

/// A single interactive segment inside [DSSegmentedTabs].
class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: SpacingTokens.spacing8),
          decoration: BoxDecoration(
            color: isSelected ? context.dsColors.primary : Colors.transparent,
            borderRadius: RadiusTokens.smRadius,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: isSelected
                  ? context.dsColors.onPrimary
                  : context.dsColors.secondary,
              fontWeight: isSelected
                  ? TypographyTokens.fontWeightSemiBold
                  : TypographyTokens.fontWeightMedium,
              height: TypographyTokens.lineHeightExtraRelaxed,
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSSegmentedTabs Preview - Light', brightness: Brightness.light)
Widget dsSegmentedTabsPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      DSSegmentedTabs(
        labels: const ['Ongoing', 'History'],
        selectedIndex: 0,
        onChanged: (_) {},
      ),
    ],
  );
}
