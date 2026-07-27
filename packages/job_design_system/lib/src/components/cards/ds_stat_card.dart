import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A compact metric card displaying a circular icon, a label, and a value.
///
/// Used to highlight quick facts such as salary, job type, or seniority level.
/// Reusable across: Job Detail (Salary / Job Type / Level), Company profiles,
/// and any place that needs a small labelled statistic.
class DSStatCard extends StatelessWidget {
  /// Icon rendered inside the circular badge.
  final IconData icon;

  /// Short caption shown above the value (e.g. "Salary").
  final String label;

  /// Emphasized value shown below the label (e.g. "\$1.5-2K").
  final String value;

  /// Icon color. Defaults to the theme primary color.
  final Color? iconColor;

  /// Circular badge background color.
  /// Defaults to a translucent tint of the theme primary color.
  final Color? iconBackgroundColor;

  /// Diameter of the circular icon badge.
  final double badgeSize;

  const DSStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.iconBackgroundColor,
    this.badgeSize = SizesTokens.size48,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? context.dsColors.primary;
    final resolvedBadgeColor =
        iconBackgroundColor ?? context.dsColors.primary.withValues(alpha: 0.12);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: resolvedBadgeColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: SizesTokens.size24, color: resolvedIconColor),
        ),
        const SizedBox(height: SpacingTokens.spacing8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.dsTextTheme.labelSmall?.copyWith(
            color: context.dsColors.secondary,
            fontWeight: TypographyTokens.fontWeightRegular,
            height: TypographyTokens.lineHeightExtraRelaxed,
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing2),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.dsTextTheme.bodyMedium?.copyWith(
            color: context.dsColors.onSurface,
            fontWeight: TypographyTokens.fontWeightSemiBold,
            height: TypographyTokens.lineHeightExtraRelaxed,
          ),
        ),
      ],
    );
  }
}

@Preview(name: 'DSStatCard Preview - Light', brightness: Brightness.light)
Widget dsStatCardPreview() {
  return DsPreviewScaffold(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          DSStatCard(
            icon: Icons.savings_outlined,
            label: 'Salary',
            value: '\$1.5-2K',
          ),
          DSStatCard(
            icon: Icons.schedule,
            label: 'Job Type',
            value: 'Full Time',
          ),
          DSStatCard(icon: Icons.bar_chart, label: 'Level', value: 'Senior'),
        ],
      ),
    ],
  );
}
