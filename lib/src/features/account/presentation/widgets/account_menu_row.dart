import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class AccountMenuRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? trailingText;
  final bool showChevron;

  const AccountMenuRow({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailingText,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: RadiusTokens.smRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SpacingTokens.spacing12),
        child: Row(
          children: [
            Icon(
              icon,
              size: SizesTokens.size24,
              color: context.dsColors.onSurfaceVariant,
            ),
            const SizedBox(width: SpacingTokens.spacing16),
            Expanded(
              child: Text(
                title,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onSurface,
                  height: TypographyTokens.lineHeightInput,
                  fontWeight: TypographyTokens.fontWeightMedium,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onSurfaceVariant,
                  height: TypographyTokens.lineHeightInput,
                  fontWeight: TypographyTokens.fontWeightRegular,
                ),
              )
            else if (showChevron)
              Icon(
                IconsaxPlusLinear.arrow_right_3,
                size: SizesTokens.size24,
                color: context.dsColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
