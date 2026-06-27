import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../imports/imports.dart';

class AppConfirmationSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color? iconBorderColor;
  final Color? confirmForegroundColor;
  final Color? confirmBackgroundColor;

  const AppConfirmationSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.icon = Icons.warning_rounded,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconBorderColor,
    this.confirmForegroundColor,
    this.confirmBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? context.dsColors.error;
    final resolvedIconBackground =
        iconBackgroundColor ??
        context.dsColors.errorContainer.withValues(alpha: 0.5);
    final resolvedIconBorder = iconBorderColor ?? context.dsColors.error;
    final resolvedConfirmForeground =
        confirmForegroundColor ?? context.dsColors.error;
    final resolvedConfirmBackground =
        confirmBackgroundColor ??
        context.dsColors.errorContainer.withValues(alpha: 0.5);

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
                  border: Border.all(color: resolvedIconBorder),
                  color: resolvedIconBackground,
                ),
                child: Icon(
                  icon,
                  color: resolvedIconColor,
                  size: SizesTokens.size40,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing32),
              Text(
                title,
                style: context.dsTextTheme.bodyLarge?.copyWith(
                  color: context.dsColors.onSurface,
                  height: TypographyTokens.lineHeightTight,
                  fontWeight: TypographyTokens.fontWeightBold,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing8),
              Text(
                message,
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
                      label: confirmLabel,
                      size: DSButtonSize.medium,
                      type: DSButtonType.secondary,
                      state: DSButtonState.primary,
                      onPressed: () => Navigator.of(context).pop(true),
                      customStyle: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide.none),
                        foregroundColor: WidgetStateProperty.all(
                          resolvedConfirmForeground,
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          resolvedConfirmBackground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.spacing16),
                  Expanded(
                    child: DSButton(
                      label: cancelLabel,
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
