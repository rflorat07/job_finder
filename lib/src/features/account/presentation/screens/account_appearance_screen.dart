import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../../../shared/services/theme_service.dart';

/// Screen that lets the user switch between Light, Dark, and System theme.
class AccountAppearanceScreen extends StatelessWidget {
  const AccountAppearanceScreen({super.key});

  static const List<_AppearanceOption> _options = [
    _AppearanceOption(
      mode: ThemeMode.light,
      titleKey: 'account.appearance_light',
      subtitleKey: 'account.appearance_light_desc',
    ),
    _AppearanceOption(
      mode: ThemeMode.dark,
      titleKey: 'account.appearance_dark',
      subtitleKey: 'account.appearance_dark_desc',
    ),
    _AppearanceOption(
      mode: ThemeMode.system,
      titleKey: 'account.appearance_automatic',
      subtitleKey: 'account.appearance_automatic_desc',
    ),
  ];

  void _onThemeSelected(ThemeMode mode) {
    themeService.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('account.appearance_title'),
        backgroundColor: context.dsColors.primaryContainer,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeService,
        builder: (context, currentMode, _) {
          return Padding(
            padding: const EdgeInsets.all(SpacingTokens.spacing24),
            child: _AppearanceSection(
              options: _options,
              selectedMode: currentMode,
              onSelected: _onThemeSelected,
            ),
          );
        },
      ),
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({
    required this.options,
    required this.selectedMode,
    required this.onSelected,
  });

  final List<_AppearanceOption> options;
  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.dsColors.secondaryContainer,
        borderRadius: RadiusTokens.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SpacingTokens.spacing16,
          SpacingTokens.spacing16,
          SpacingTokens.spacing16,
          SpacingTokens.spacing16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(
                height: SpacingTokens.spacing12,
              ),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option.mode == selectedMode;

                return _AppearanceTile(
                  title: context.tr(option.titleKey),
                  subtitle: context.tr(option.subtitleKey),
                  isSelected: isSelected,
                  onTap: () => onSelected(option.mode),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearanceTile extends StatelessWidget {
  const _AppearanceTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: RadiusTokens.mdRadius,
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.spacing16),
        decoration: BoxDecoration(
          borderRadius: RadiusTokens.mdRadius,
          border: isSelected
              ? Border.all(
                  color: context.dsColors.outline,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.dsTextTheme.bodyMedium?.copyWith(
                      color: context.dsColors.onSurface,
                      fontWeight: TypographyTokens.fontWeightBold,
                      height: TypographyTokens.lineHeightInput,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.spacing4),
                  Text(
                    subtitle,
                    style: context.dsTextTheme.bodySmall?.copyWith(
                      color: context.dsColors.onSurfaceVariant,
                      fontWeight: TypographyTokens.fontWeightRegular,
                      height: TypographyTokens.lineHeightRelaxed,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpacingTokens.spacing12),
            Container(
              width: SizesTokens.size24,
              height: SizesTokens.size24,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.dsColors.primary
                    : context.dsColors.outline.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: context.dsColors.secondaryContainer,
                      size: SizesTokens.size14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearanceOption {
  const _AppearanceOption({
    required this.mode,
    required this.titleKey,
    required this.subtitleKey,
  });

  final ThemeMode mode;
  final String titleKey;
  final String subtitleKey;
}
