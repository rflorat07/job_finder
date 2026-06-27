import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

Future<bool?> showAccountLogoutConfirmationSheet() {
  return showAppSheet<bool>(
    child: const AccountLogoutConfirmationSheet(),
  );
}

class AccountLogoutConfirmationSheet extends StatelessWidget {
  const AccountLogoutConfirmationSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfirmationSheet(
      title: context.tr('account.logout_title'),
      message: context.tr('account.logout_confirmation'),
      confirmLabel: context.tr('account.logout_confirm'),
      cancelLabel: context.tr('account.cancel'),
      icon: Icons.warning_rounded,
      iconColor: context.dsColors.error,
      iconBorderColor: context.dsColors.error,
      iconBackgroundColor: context.dsColors.errorContainer.withValues(
        alpha: 0.5,
      ),
      confirmForegroundColor: context.dsColors.error,
      confirmBackgroundColor: context.dsColors.errorContainer.withValues(
        alpha: 0.5,
      ),
    );
  }
}
