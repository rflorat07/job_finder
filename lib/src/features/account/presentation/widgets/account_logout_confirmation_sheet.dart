import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class AccountLogoutConfirmationSheet extends StatelessWidget {
  const AccountLogoutConfirmationSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.dsColors.tertiaryContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.xl3),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SpacingTokens.spacing24,
            SpacingTokens.spacing32,
            SpacingTokens.spacing24,
            SpacingTokens.spacing8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: SizesTokens.size80,
                height: SizesTokens.size80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.dsColors.error),
                  color: context.dsColors.errorContainer.withValues(alpha: 0.5),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: context.dsColors.error,
                  size: SizesTokens.size40,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing32),
              Text(
                context.tr('account.logout_title'),
                style: context.dsTextTheme.bodyLarge?.copyWith(
                  color: context.dsColors.onSurface,
                  height: TypographyTokens.lineHeightTight,
                  fontWeight: TypographyTokens.fontWeightBold,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing8),
              Text(
                context.tr('account.logout_confirmation'),
                textAlign: TextAlign.center,
                style: context.dsTextTheme.bodySmall?.copyWith(
                  color: context.dsColors.onSurfaceVariant,
                  fontWeight: TypographyTokens.fontWeightRegular,
                  height: TypographyTokens.lineHeightExtraRelaxed,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing32),
              Row(
                children: [
                  Expanded(
                    child: DSButton(
                      label: context.tr('account.logout_confirm'),
                      size: DSButtonSize.medium,
                      type: DSButtonType.secondary,
                      state: DSButtonState.primary,
                      onPressed: () => Navigator.of(context).pop(true),
                      customStyle: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide.none),
                        foregroundColor: WidgetStateProperty.all(
                          context.dsColors.error,
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          context.dsColors.errorContainer.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.spacing16),
                  Expanded(
                    child: DSButton(
                      label: context.tr('account.cancel'),
                      size: DSButtonSize.medium,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
