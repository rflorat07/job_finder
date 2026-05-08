import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.forgot_password_title'),
      showBackButton: true,
      icon: IconsaxPlusLinear.arrow_left_1,
      onPressed: () => context.go(AppRoutes.otpVerification),
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
        ],
      ),
    );
  }
}

class _ForgotPasswordEmailForm extends StatefulWidget {
  const _ForgotPasswordEmailForm();

  @override
  State<_ForgotPasswordEmailForm> createState() =>
      _ForgotPasswordEmailFormState();
}

class _ForgotPasswordEmailFormState extends State<_ForgotPasswordEmailForm> {
  late final ForgotPasswordViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ForgotPasswordViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
              spacing: SpacingTokens.spacing16,
              children: [
                DSTextFormField(
                  label: context.tr('auth.email_address'),
                  hint: context.tr('auth.email_hint'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  controller: _emailController,
                  validator: (val) => AppValidators.validateEmail(context, val),
                ),

                const Spacer(),

                DSButton(
                  label: context.tr('auth.send_code'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      _viewModel.sendResetLink(
                        _emailController.text,
                        onSuccess: () {
                          showGlobalToast(
                            message: 'Código enviado exitosamente',
                            status: 'success',
                          );
                          context.go(AppRoutes.otpVerification);
                        },
                        onError: (errorMessage) {
                          showGlobalToast(
                            message: errorMessage,
                            status: 'error',
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
