import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('log_in.welcome_back'),
      subtitle: context.tr('shared.lorem'),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LoginEmailForm(),
          Spacer(),
          _LoginFooterLink(),
          // Don't have an account link
        ],
      ),
    );
  }
}

class _LoginEmailForm extends StatelessWidget {
  const _LoginEmailForm();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: SpacingTokens.spacing16,
        children: [
          DSTextFormField(
            label: context.tr('auth.email'),
            hint: context.tr('auth.email_hint'),
            keyboardType: TextInputType.emailAddress,
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
                onTap: () => context.go(AppRoutes.forgotPassword),
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
        ],
      ),
    );
  }
}

class _LoginFooterLink extends StatelessWidget {
  const _LoginFooterLink();

  @override
  Widget build(BuildContext context) {
    // Sign up link at the bottom
    return DSRichText(
      text: context.tr('auth.dont_have_account'),
      linkText: context.tr('auth.register'),
      onLinkTap: () => context.go(AppRoutes.register),
    );
  }
}
