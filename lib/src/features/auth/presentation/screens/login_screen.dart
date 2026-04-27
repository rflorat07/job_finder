import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthTabBarBaseLayout(
      backgroundColor: Colors.green,
      title: context.tr('log_in.welcome_back'),
      subtitle: context.tr('shared.lorem'),
      tabs: [
        Tab(text: context.tr('auth.phone_number')),
        Tab(text: context.tr('auth.email')),
      ],
      tabViews: const [
        PhoneNumberLoginForm(),
        EmailLoginForm(),
      ],
    );
  }
}

class PhoneNumberLoginForm extends StatelessWidget {
  const PhoneNumberLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: SpacingTokens.spacing16),
      child: Column(
        spacing: SpacingTokens.spacing16,
        children: [
          DSTextFormField(
            label: context.tr('auth.phone_number'),
            hint: context.tr('auth.phone_number_hint'),
            keyboardType: TextInputType.phone,
          ),

          DSTextFormField(
            label: context.tr('auth.password'),
            hint: context.tr('auth.password_hint'),
            keyboardType: TextInputType.text,
            suffixIcon: const Icon(IconsaxPlusLinear.eye),
            obscureText: true,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: SpacingTokens.spacing16,
                  ),
                  child: Text(
                    context.tr('auth.forgot_password'),
                    style: context.dsTextTheme.bodySmall?.copyWith(
                      color: context.dsColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          DSButton(
            label: context.tr('log_in.log_in'),
            //onPressed: () {},
          ),

          DSDivider(label: context.tr('auth.or_continue_with')),

          Row(
            spacing: SpacingTokens.spacing16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DSSocialButton(
                iconOnly: true,
                type: DSSocialButtonType.google,
                label: context.tr('auth.sign_in_google'),
                onPressed: () {},
              ),
              DSSocialButton(
                iconOnly: true,
                type: DSSocialButtonType.apple,
                label: context.tr('auth.sign_in_apple'),
                onPressed: () {},
              ),
              DSSocialButton(
                iconOnly: true,
                type: DSSocialButtonType.facebook,
                label: context.tr('auth.sign_in_facebook'),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: SpacingTokens.spacing40),

          DSRichText(
            text: context.tr('auth.dont_have_account'),
            linkText: context.tr('auth.sign_up'),
            onLinkTap: () {},
          ),
        ],
      ),
    );
  }
}

class EmailLoginForm extends StatelessWidget {
  const EmailLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
