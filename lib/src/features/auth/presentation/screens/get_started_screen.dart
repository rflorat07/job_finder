import 'package:go_router/go_router.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/core_imports.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('shared.get_started'),
      subtitle: context.tr('shared.lorem'),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _GetStartedAuthForm(), // Email and Continue button
          SizedBox(height: SpacingTokens.spacing24),
          _GetStartedSocialLogin(), // Divider and Social buttons
          Spacer(),
          _GetStartedFooterLink(), // Don't have an account link
        ],
      ),
    );
  }
}

class _GetStartedAuthForm extends StatelessWidget {
  const _GetStartedAuthForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Email Address field
        DSTextFormField(
          label: context.tr('auth.email_address'),
          hint: context.tr('auth.email_hint'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: SpacingTokens.spacing16),
        // Continue button
        DSButton(
          label: context.tr('shared.continue'),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}

class _GetStartedSocialLogin extends StatelessWidget {
  const _GetStartedSocialLogin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Social login divider
        DSDivider(label: context.tr('auth.or_continue_with')),
        const SizedBox(height: SpacingTokens.spacing24),
        // Apple sign in button
        DSSocialButton(
          type: DSSocialButtonType.apple,
          label: context.tr('auth.sign_in_apple'),
          onPressed: () {},
        ),
        const SizedBox(height: SpacingTokens.spacing16),
        // Google sign in button
        DSSocialButton(
          type: DSSocialButtonType.google,
          label: context.tr('auth.sign_in_google'),
          onPressed: () {},
        ),
        const SizedBox(height: SpacingTokens.spacing16),
        // Facebook sign in button
        DSSocialButton(
          type: DSSocialButtonType.facebook,
          label: context.tr('auth.sign_in_facebook'),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _GetStartedFooterLink extends StatelessWidget {
  const _GetStartedFooterLink();

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
