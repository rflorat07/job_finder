import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSHotVacancyCard extends StatelessWidget {
  final String companyName;
  final String openJobs;
  final DSDynamicIcon logoIcon;
  final VoidCallback? onTap;

  const DSHotVacancyCard({
    super.key,
    required this.companyName,
    required this.openJobs,
    required this.logoIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing16,
          vertical: SpacingTokens.spacing20,
        ),
        decoration: BoxDecoration(
          color: context.dsColors.surface,
          borderRadius: RadiusTokens.lgRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: RadiusTokens.lg,
              offset: const Offset(0, SpacingTokens.spacing4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoIcon,

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
            logoIcon: DSDynamicIcon.svgAsset(
              'assets/icons/apple.svg',
              backgroundColor: const Color(0xFFF3F4F6), // Un fondo gris clarito
            ),
          ),

          DSHotVacancyCard(
            companyName: 'Shopify',
            openJobs: '5 Jobs open',
            logoIcon: DSDynamicIcon.svgAsset(
              'assets/icons/shopify.svg',
              backgroundColor: const Color(0xFFE5F1E5), // Verde clarito
            ),
          ),
        ],
      ),
    ],
  );
}
