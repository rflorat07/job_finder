import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const DSSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.dsTextTheme.bodyLarge?.copyWith(
            color: context.dsColors.onSurface,
            height: TypographyTokens.lineHeightExtraRelaxed,
          ),
        ),
        if (actionText != null)
          InkWell(
            onTap: onActionPressed,
            hoverColor: Colors.transparent,
            borderRadius: BorderRadius.circular(RadiusTokens.xsm),
            child: Text(
              actionText!,
              style: context.dsTextTheme.bodySmall?.copyWith(
                color: context.dsColors.primary,
                letterSpacing: TypographyTokens.letterSpacingWide,
                height: TypographyTokens.lineHeightExtraRelaxed,
              ),
            ),
          ),
      ],
    );
  }
}

@Preview(name: 'DSSectionHeader Preview - Light', brightness: Brightness.light)
Widget dsSectionHeaderLightPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DSSectionHeader(title: 'Hot Vacancies'),

          DSSectionHeader(
            title: 'Best Matches',
            actionText: 'See All',
            onActionPressed: () {},
          ),
        ],
      ),
    ],
  );
}
