import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';

class SetupAccountStep3Screen extends StatefulWidget {
  final SetupAccountViewModel viewModel;

  const SetupAccountStep3Screen({
    super.key,
    required this.viewModel,
  });

  @override
  State<SetupAccountStep3Screen> createState() =>
      _SetupAccountStep3ScreenState();
}

class _SetupAccountStep3ScreenState extends State<SetupAccountStep3Screen> {
  void _onNextStep() {
    // context.push(AppRoutes.setupAccountStep4, extra: widget.viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return DSSetupAccountBaseLayout(
          currentStep: 3,
          onPressed: () => context.canPop() ? context.pop() : null,
          totalSteps: widget.viewModel.totalSteps,
          title: context.tr('setup_account.follow_official_account'),
          subtitle: context.tr(
            'setup_account.follow_official_account_subtitle',
          ),
          bottomAction: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DSButton(
                onPressed: _onNextStep,
                label: context.tr('shared.continue'),
              ),
              DSButton(
                onPressed: _onNextStep,
                label: context.tr('shared.skip'),
                type: DSButtonType.tertiary,
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: OfficialAccountEntity.mocks.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: SpacingTokens.spacing24),
            itemBuilder: (context, index) {
              final officialAccount = OfficialAccountEntity.mocks[index];
              final isSelected = widget.viewModel.selectedOfficialAccounts
                  .contains(officialAccount);
              return DsCompany(
                name: officialAccount.name,
                logoUrl: officialAccount.logoUrl,
                isFollowed: isSelected,
                followersCount: officialAccount.followersCount,
                onSelected: (_) =>
                    widget.viewModel.toggleOfficialAccount(officialAccount),
              );
            },
          ),
        );
      },
    );
  }
}
