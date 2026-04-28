import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.create_account'),
      subtitle: context.tr('shared.lorem'),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RegisterEmailForm(),
          Spacer(),
          _RegisterFooterLink(),
          // Don't have an account link
        ],
      ),
    );
  }
}

class _RegisterEmailForm extends StatelessWidget {
  const _RegisterEmailForm();

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

          DSTextFormField(
            label: context.tr('auth.confirm_password'),
            hint: context.tr('auth.password_hint'),
            keyboardType: TextInputType.text,
            suffixIcon: const Icon(IconsaxPlusLinear.eye),
            obscureText: true,
          ),

          DSRichText(
            text: context.tr('auth.terms_and_conditions'),
            fontWeight: TypographyTokens.fontWeightRegular,
            linkText: context.tr('auth.terms_and_conditions_details'),
            onLinkTap: () {
              // Handle terms and conditions tap
            },
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: SpacingTokens.spacing24,
            ),
            child: DSButton(
              label: context.tr('auth.register'),
              //onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterFooterLink extends StatelessWidget {
  const _RegisterFooterLink();

  @override
  Widget build(BuildContext context) {
    // Sign up link at the bottom
    return DSRichText(
      text: context.tr('auth.already_have_account'),
      linkText: context.tr('auth.login_button'),
      onLinkTap: () => context.go(AppRoutes.login),
    );
  }
}
