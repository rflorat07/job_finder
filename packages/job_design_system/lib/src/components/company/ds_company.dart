import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DsCompany extends StatelessWidget {
  const DsCompany({
    super.key,
    required this.name,
    this.logoUrl,
    this.onSelected,
    this.isFollowed,
    this.followersCount,
  });

  /// The name of the company.
  final String name;

  /// An optional URL to the company's logo.
  final String? logoUrl;

  /// Whether the company is currently followed.
  final bool? isFollowed;

  /// The number of followers the company has.
  final double? followersCount;

  /// Callback when the chip is tapped.
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logoUrl != null) ...[
          DSRoundedContainer(
            width: SizesTokens.size56,
            height: SizesTokens.size56,
            backgroundColor: context.dsIsDarkMode
                ? SemanticColorsDark.companyBackgroundColor
                : SemanticColorsLight.companyBackgroundColor,
            borderRadius: BorderRadius.circular(SizesTokens.size28),
            child: Center(
              child: DSIconAsset(
                assetName: logoUrl!,
                width: SizesTokens.size24,
                height: SizesTokens.size24,
              ),
            ),
          ),
          const SizedBox(width: SpacingTokens.spacing16),
        ],

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TypographyTokens.bodyMedium.copyWith(
                  color: SemanticColorsLight.textPrimary,
                ),
              ),
              if (followersCount != null) ...[
                const SizedBox(height: SpacingTokens.spacing4),
                Text(
                  '${followersCount!.toStringAsFixed(0)} Followers',
                  style: TypographyTokens.bodySmall.copyWith(
                    color: SemanticColorsLight.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),

        Flexible(
          child: DSButton(
            onPressed: () => onSelected?.call(!(isFollowed ?? false)),
            label: isFollowed == true ? 'Following' : 'Follow',
            type: isFollowed == true
                ? DSButtonType.primary
                : DSButtonType.secondary,
            size: DSButtonSize.xsmall,
          ),
        ),
      ],
    );
  }
}

@Preview(name: 'DsCompany Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DsCompany Preview - Dark', brightness: Brightness.dark)
Widget dsCompanyLightDarkPreview() {
  return DsPreviewScaffold(
    backgroundColor: Color(PrimitiveColors.greyscale25),
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DsCompany(
            name: 'Google LLC',
            logoUrl: 'assets/icons/google.svg',
            isFollowed: false,
            followersCount: 9000,
            onSelected: (_) {},
          ),
        ],
      ),
    ],
  );
}
