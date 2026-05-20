import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSHotVacancyCard extends StatelessWidget {
  final String companyName;
  final String openJobs;
  final String logoUrl;
  final Color networkIconBackground;
  final Color svgIconBackground;
  final VoidCallback? onTap;

  const DSHotVacancyCard({
    super.key,
    required this.companyName,
    required this.openJobs,
    required this.logoUrl,
    this.networkIconBackground = const Color(0xFFF3F4F6),
    this.svgIconBackground = const Color(0xFFE5F1E5),
    this.onTap,
  });

  /// Resolves the logo icon based on whether [logoUrl] is a network URL or a local SVG asset.
  DSDynamicIcon _buildLogoIcon() {
    if (logoUrl.startsWith('http')) {
      return DSDynamicIcon.network(
        logoUrl,
        backgroundColor: networkIconBackground,
      );
    }
    return DSDynamicIcon.svgAsset(logoUrl, backgroundColor: svgIconBackground);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing16,
          vertical: SpacingTokens.spacing20,
        ),
        decoration: BoxDecoration(
          color: context.dsColors.primaryContainer,
          borderRadius: RadiusTokens.lgRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogoIcon(),

            const SizedBox(height: SpacingTokens.spacing12),

            Text(
              companyName,
              style: context.dsTextTheme.bodySmall?.copyWith(
                color: context.dsColors.onSurface,
                height: TypographyTokens.lineHeightExtraRelaxed,
                letterSpacing: TypographyTokens.letterSpacingTight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              openJobs,
              style: TypographyTokens.bodyXSmall.copyWith(
                color: context.dsColors.secondary,
                fontWeight: TypographyTokens.fontWeightRegular,
                height: TypographyTokens.lineHeightExtraRelaxed,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'DSHotVacancyCard Preview - Light', brightness: Brightness.light)
Widget dsHotVacancyCardLightPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      Row(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSHotVacancyCard(
            companyName: 'Stripe',
            openJobs: '8 Jobs open',
            logoUrl: 'assets/icons/apple.svg',
          ),

          DSHotVacancyCard(
            companyName: 'Shopify',
            openJobs: '5 Jobs open',
            logoUrl: 'assets/icons/shopify.svg',
          ),
        ],
      ),
    ],
  );
}
