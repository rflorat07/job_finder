import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/core_imports.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('shared.get_started'),
      subtitle: context.tr('shared.lorem'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Email Address label
          DSTextFormField(
            label: context.tr('auth.email_address'),
            hint: context.tr('auth.email_hint'),
            keyboardType: TextInputType.emailAddress,
          ),

          // Input field
          const SizedBox(height: SpacingTokens.spacing16),

          // Continue button
          DSButton(
            label: context.tr('shared.continue'),
            onPressed: () {},
          ),

          const SizedBox(height: SpacingTokens.spacing24),

          DSDivider(label: context.tr('auth.or_continue_with')),

          const SizedBox(height: SpacingTokens.spacing24),

          DSSocialButton(
            type: DSSocialButtonType.apple,
            label: context.tr('auth.sign_in_apple'),
            onPressed: () {},
          ),

          const SizedBox(height: SpacingTokens.spacing16),

          DSSocialButton(
            type: DSSocialButtonType.google,
            label: context.tr('auth.sign_in_google'),
            onPressed: () {},
          ),
          const SizedBox(height: SpacingTokens.spacing16),

          DSSocialButton(
            type: DSSocialButtonType.facebook,
            label: context.tr('auth.sign_in_facebook'),
            onPressed: () {},
          ),

          const SizedBox(height: SpacingTokens.spacing24),

          const Spacer(),

          DSRichText(
            text: context.tr('auth.dont_have_account'),
            linkText: context.tr('auth.sign_up'),
            onLinkTap: () {
              // Handle sign up tap
            },
          ),
        ],
      ),
    );
  }
}
