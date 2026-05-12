import 'package:job_design_system/job_design_system.dart';

import '../../../../imports/imports.dart';

class SetupAccountStep extends StatelessWidget {
  const SetupAccountStep({super.key});

  @override
  Widget build(BuildContext context) {
    return DSSetupAccountBaseLayout(
      currentStep: 1,
      totalSteps: 4,
      title: context.tr('setup_account.setup_account_title'),
      subtitle: context.tr('setup_account.setup_account_subtitle'),
      bottomAction: DSButton(
        onPressed: null,
        label: context.tr('setup_account.continue'),
      ),
      child: Column(
        children: [
          Text(
            context.tr('shared.lorem'),
          ),
        ],
      ),
    );
  }
}
