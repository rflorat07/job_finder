import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../controllers/controllers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final ForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = SupabaseAuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);

    _viewModel = ForgotPasswordViewModel(authRepository: authRepository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.forgot_password_title'),
      showBackButton: true,
      icon: IconsaxPlusLinear.arrow_left_1,
      onPressed: () => context.go(AppRoutes.login),
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

          _ForgotPasswordEmailForm(viewModel: _viewModel),
        ],
      ),
    );
  }
}

class _ForgotPasswordEmailForm extends StatefulWidget {
  final ForgotPasswordViewModel viewModel;
  const _ForgotPasswordEmailForm({required this.viewModel});

  @override
  State<_ForgotPasswordEmailForm> createState() =>
      _ForgotPasswordEmailFormState();
}

class _ForgotPasswordEmailFormState extends State<_ForgotPasswordEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final isLoading = widget.viewModel.isLoading;

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
                  width: double.infinity,
                  label: context.tr('auth.send_code'),
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            widget.viewModel.sendResetLink(
                              _emailController.text,
                              onSuccess: () {
                                DSToast.showSuccess(
                                  context: context,
                                  message: 'Código enviado exitosamente',
                                );
                                // Pasamos el correo a la siguiente vista
                                context.go(
                                  AppRoutes.otpVerification,
                                  extra: _emailController.text,
                                );
                              },
                              onError: (errorMessage) {
                                DSToast.showError(
                                  context: context,
                                  message: errorMessage,
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
