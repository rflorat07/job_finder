import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';

class SetupAccountStep2Screen extends StatefulWidget {
  final SetupAccountViewModel viewModel;

  const SetupAccountStep2Screen({
    super.key,
    required this.viewModel,
  });

  @override
  State<SetupAccountStep2Screen> createState() =>
      _SetupAccountStep2ScreenState();
}

class _SetupAccountStep2ScreenState extends State<SetupAccountStep2Screen> {
  void _onNextStep() {
    // context.push(AppRoutes.setupAccountStep3, extra: widget.viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return DSSetupAccountBaseLayout(
          currentStep: 2,
          onPressed: () => context.canPop() ? context.pop() : null,
          totalSteps: widget.viewModel.totalSteps,
          title: context.tr('setup_account.what_is_your_expertise'),
          subtitle: context.tr('setup_account.what_is_your_expertise_subtitle'),
          bottomAction: DSButton(
            onPressed: widget.viewModel.isStep2Valid ? _onNextStep : null,
            label: context.tr('setup_account.continue'),
          ),
          child: Wrap(
            spacing: SpacingTokens.spacing8,
            runSpacing: SpacingTokens.spacing8,
            children: ExpertiseEntity.mocks.map((expertise) {
              final isSelected = widget.viewModel.isExpertiseSelected(
                expertise,
              );
              return FilterChip(
                label: Text(expertise.name),
                selected: isSelected,
                onSelected: (_) => widget.viewModel.toggleExpertise(expertise),
                selectedColor: context.dsColors.primary,
                checkmarkColor: context.dsColors.onPrimary,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? context.dsColors.onPrimary
                      : context.dsColors.onSurface,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(RadiusTokens.lg),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : context.dsColors.outlineVariant,
                  ),
                ),
                backgroundColor: context.dsColors.surface,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
