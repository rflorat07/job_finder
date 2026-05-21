import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSCountry extends StatelessWidget {
  const DSCountry({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.countryName,
    required this.countryFlagAsset,
  });

  final VoidCallback onTap;
  final String countryName;
  final String countryFlagAsset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SpacingTokens.spacing20,
          horizontal: SpacingTokens.spacing16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.dsColors.onSecondaryContainer
              : context.dsColors.secondaryContainer,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          border: isSelected
              ? Border.all(color: context.dsColors.primary, width: 1)
              : null,
        ),
        child: Row(
          children: [
            DSIconAsset(width: SizesTokens.size40, assetName: countryFlagAsset),
            const SizedBox(width: SpacingTokens.spacing16),
            Expanded(
              child: Text(
                countryName,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  fontWeight: TypographyTokens.fontWeightMedium,
                  height: TypographyTokens.lineHeightInput,
                ),
              ),
            ),
            isSelected
                ? DSIconAsset(
                    height: SizesTokens.size20,
                    assetName: 'assets/icons/check.svg',
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'DSCountry Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSCountry Preview - Dark', brightness: Brightness.dark)
Widget dsCountryLightDarkPreview() {
  return DsPreviewScaffold(
    backgroundColor: Color(PrimitiveColors.greyscale25),
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSCountry(
            onTap: () {},
            isSelected: true,
            countryName: 'United States',
            countryFlagAsset: 'assets/flags/us.svg',
          ),
        ],
      ),
    ],
  );
}
