import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class AccountLogoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const AccountLogoutButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DSButton(
      width: double.infinity,
      height: SizesTokens.size48,
      label: context.tr('account.logout'),
      type: DSButtonType.secondary,
      state: DSButtonState.primary,
      isLoading: isLoading,
      onPressed: onPressed,
      icon: const Icon(IconsaxPlusLinear.logout_1),
      customStyle: ButtonStyle(
        side: WidgetStateProperty.all(
          BorderSide(color: context.dsColors.error),
        ),
        foregroundColor: WidgetStateProperty.all(
          context.dsColors.error,
        ),
      ),
    );
  }
}
