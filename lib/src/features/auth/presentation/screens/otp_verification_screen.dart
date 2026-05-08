import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.forgot_password_title'),
      showBackButton: true,
      icon: IconsaxPlusLinear.arrow_left_1,
      onPressed: () => context.go(AppRoutes.login),
      child: const Column(
        spacing: SpacingTokens.spacing24,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _OtpVerificationHeader(),
          _OtpVerificationForm(),
        ],
      ),
    );
  }
}

class _OtpVerificationForm extends StatefulWidget {
  const _OtpVerificationForm();

  @override
  State<_OtpVerificationForm> createState() => _OtpVerificationFormState();
}

class _OtpVerificationFormState extends State<_OtpVerificationForm> {
  late final OtpVerificationViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = OtpVerificationViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp(String pinCode) {
    if (pinCode.length == 5) {
      FocusScope.of(context).unfocus();

      _viewModel.verifyCode(
        pinCode,
        onSuccess: () {
          showGlobalToast(message: 'Success!', status: 'success');
          // context.go(AppRoutes.resetPassword);
        },
        onError: (error) {
          showGlobalToast(message: error, status: 'error');
          _otpController.clear();
        },
      );
    }
  }

  void _resendCode() {
    _viewModel.resendCode(
      onCodeResent: () => showGlobalToast(
        message: 'A new code has been sent to your email.',
        status: 'success',
      ),
      onError: (error) => showGlobalToast(message: error, status: 'error'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          final isLoading = _viewModel.isLoading;

          return Form(
            key: _formKey,
            child: Column(
              spacing: SpacingTokens.spacing32,
              children: [
                DSOtpInput(
                  controller: _otpController,
                  length: 5,
                ),

                _OtpVerificationLink(onLinkTap: () => _resendCode()),

                const Spacer(),

                DSButton(
                  label: context.tr('auth.otp_verify'),
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () => _verifyOtp(_otpController.text),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OtpVerificationLink extends StatelessWidget {
  const _OtpVerificationLink({required this.onLinkTap});

  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    // Sign up link at the bottom
    return DSRichText(
      text: context.tr('auth.otp_verification_not_received_the_code'),
      linkText: context.tr('auth.otp_verification_resend_code'),
      onLinkTap: onLinkTap,
    );
  }
}

class _OtpVerificationHeader extends StatelessWidget {
  const _OtpVerificationHeader();

  @override
  Widget build(BuildContext context) {
    // Sign up link at the bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const DSIconAsset(
          width: Sizes.size64,
          height: Sizes.size64,
          assetName: 'assets/icons/otp_verification.svg',
        ),

        const SizedBox(height: SpacingTokens.spacing32),

        Text(
          context.tr('auth.otp_verification_title'),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: TypographyTokens.fontWeightBold,
            height: TypographyTokens.lineHeightRelaxed,
          ),
        ),

        Text(
          context.tr('auth.otp_verification_subtitle'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.dsColors.secondary,
            fontWeight: TypographyTokens.fontWeightRegular,
            height: TypographyTokens.lineHeightExtraRelaxed,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
