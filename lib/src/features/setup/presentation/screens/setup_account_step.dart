import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

class SetupAccountStep extends StatefulWidget {
  const SetupAccountStep({super.key});

  @override
  State<SetupAccountStep> createState() => _SetupAccountStepState();
}

class _SetupAccountStepState extends State<SetupAccountStep> {
  late final SetupAccountViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SetupAccountViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _showCountrySelector() async {
    final selectedCountry = await CountrySelectionBottomSheet.show(
      context,
      initialSelection: _viewModel.selectedCountry,
    );

    if (selectedCountry != null) {
      _viewModel.selectCountry(selectedCountry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return DSSetupAccountBaseLayout(
          currentStep: 1,
          totalSteps: 4,
          title: context.tr('setup_account.setup_account_title'),
          subtitle: context.tr('setup_account.setup_account_subtitle'),
          bottomAction: DSButton(
            onPressed: _viewModel.isStep1Valid
                ? () {} //TODO: Navegar al siguiente paso
                : null,
            label: context.tr('setup_account.continue'),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('setup_account.country'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: TypographyTokens.fontWeightMedium,
                ),
              ),

              const SizedBox(height: SpacingTokens.spacing8),

              _CountrySelectorInput(
                selectedCountry: _viewModel.selectedCountry,
                onTap: _showCountrySelector,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CountrySelectorInput extends StatelessWidget {
  final CountryEntity? selectedCountry;
  final VoidCallback onTap;

  const _CountrySelectorInput({
    required this.selectedCountry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Abre el modal
      borderRadius: BorderRadius.circular(RadiusTokens.xsm),
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.spacing12),
        decoration: BoxDecoration(
          color: context.dsColors.surface,
          border: Border.all(
            color: context.dsColors.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(RadiusTokens.xsm),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedCountry == null
                  ? Text(
                      context.tr('setup_account.select_your_country'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.dsColors.secondary,
                        fontWeight: TypographyTokens.fontWeightRegular,
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          selectedCountry!.flagEmoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: SpacingTokens.spacing12),
                        Text(
                          selectedCountry!.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: TypographyTokens.fontWeightMedium,
                              ),
                        ),
                      ],
                    ),
            ),
            Icon(
              IconsaxPlusLinear.arrow_down,
              color: context.dsColors.secondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
