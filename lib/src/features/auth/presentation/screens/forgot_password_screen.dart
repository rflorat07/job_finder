import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.forgot_password'),
      subtitle: context.tr('shared.lorem'),
      child: Column(
        spacing: SpacingTokens.spacing24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: SpacingTokens.spacing4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('auth.email_hint'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: TypographyTokens.fontWeightBold,
                  height: TypographyTokens.lineHeightRelaxed,
                ),
              ),

              Text(
                context.tr('shared.lorem'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.dsColors.secondary,
                  fontWeight: TypographyTokens.fontWeightRegular,
                  height: TypographyTokens.lineHeightExtraRelaxed,
                ),
              ),
            ],
          ),

          const _ForgotPasswordEmailForm(),

          const Spacer(),

          DSButton(
            label: context.tr('auth.send_code'),
            //onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordEmailForm extends StatelessWidget {
  const _ForgotPasswordEmailForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SpacingTokens.spacing16,
      children: [
        DSTextFormField(
          label: context.tr('auth.email_address'),
          hint: context.tr('auth.email_hint'),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
