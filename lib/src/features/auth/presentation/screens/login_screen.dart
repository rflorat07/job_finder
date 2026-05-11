import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../controllers/controllers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    final remoteDataSource = SupabaseAuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);

    _viewModel = LoginViewModel(authRepository: authRepository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('log_in.welcome_back'),
      subtitle: context.tr('shared.lorem'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LoginEmailForm(viewModel: _viewModel),
          const Spacer(),
          const _LoginFooterLink(),
          // Don't have an account link
        ],
      ),
    );
  }
}

class _LoginEmailForm extends StatefulWidget {
  final LoginViewModel viewModel;

  const _LoginEmailForm({required this.viewModel});

  @override
  State<_LoginEmailForm> createState() => _LoginEmailFormState();
}

class _LoginEmailFormState extends State<_LoginEmailForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      widget.viewModel.login(
        _emailController.text,
        _passwordController.text,
        onError: (errorMessage) {
          DSToast.showError(context: context, message: errorMessage);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final isLoading = widget.viewModel.isLoading;
        final isVisible = widget.viewModel.isPasswordVisible;

        return Form(
          key: _formKey,
          child: Column(
            spacing: SpacingTokens.spacing16,
            children: [
              DSTextFormField(
                controller: _emailController,
                label: context.tr('auth.email'),
                hint: context.tr('auth.email_hint'),
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                validator: (value) =>
                    AppValidators.validateEmail(context, value),
              ),

              DSTextFormField(
                controller: _passwordController,
                label: context.tr('auth.password'),
                hint: context.tr('auth.password_hint'),
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                validator: (value) =>
                    AppValidators.validatePassword(context, value),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible
                        ? IconsaxPlusLinear.eye_slash
                        : IconsaxPlusLinear.eye,
                  ),
                  onPressed: widget.viewModel.togglePasswordVisibility,
                ),
                obscureText: !isVisible,
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
                onPressed: isLoading ? null : _submitForm,
                isLoading: isLoading,
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
      },
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
