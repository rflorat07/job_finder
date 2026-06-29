import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

/// Screen that lets the user switch between the app's supported locales.
class AccountLanguageScreen extends StatelessWidget {
  const AccountLanguageScreen({super.key});

  static const List<_LanguageOption> _languageOptions = [
    _LanguageOption(
      locale: Locale('en'),
      labelKey: 'account.language_english',
    ),
    _LanguageOption(
      locale: Locale('es'),
      labelKey: 'account.language_spanish',
    ),
    _LanguageOption(
      locale: Locale('it'),
      labelKey: 'account.language_italian',
    ),
  ];

  Future<void> _onLanguageSelected(
    BuildContext context,
    Locale locale,
  ) async {
    if (context.locale.languageCode == locale.languageCode) {
      return;
    }

    await context.setLocale(locale);

    if (!context.mounted) {
      return;
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCode = context.locale.languageCode;

    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('account.language_title'),
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
      body: Padding(
        padding: const EdgeInsets.all(SpacingTokens.spacing24),
        child: _LanguageSection(
          title: context.tr('account.available_languages'),
          options: _languageOptions,
          selectedCode: selectedCode,
          onSelected: (locale) => _onLanguageSelected(context, locale),
        ),
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({
    required this.title,
    required this.options,
    required this.selectedCode,
    required this.onSelected,
  });

  final String title;
  final List<_LanguageOption> options;
  final String selectedCode;
  final ValueChanged<Locale> onSelected;

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
          SpacingTokens.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.dsTextTheme.labelSmall?.copyWith(
                color: context.dsColors.onSurfaceVariant,
                height: TypographyTokens.lineHeightExtraRelaxed,
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (_, _) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SpacingTokens.spacing16,
                ),
                child: Divider(
                  color: context.dsColors.outline.withValues(alpha: 0.25),
                  height: 1,
                  thickness: 1,
                ),
              ),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option.locale.languageCode == selectedCode;

                return _LanguageTile(
                  title: context.tr(option.labelKey),
                  isSelected: isSelected,
                  onTap: () => onSelected(option.locale),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.dsTextTheme.bodyMedium?.copyWith(
                color: context.dsColors.onSurface,
                fontWeight: TypographyTokens.fontWeightMedium,
                height: TypographyTokens.lineHeightInput,
              ),
            ),
          ),
          if (isSelected)
            Container(
              width: SizesTokens.size20,
              height: SizesTokens.size20,
              decoration: BoxDecoration(
                color: context.dsColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: context.dsColors.onPrimary,
                size: SizesTokens.size14,
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.locale,
    required this.labelKey,
  });

  final Locale locale;
  final String labelKey;
}
