import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../controllers/controllers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Inyección manual de dependencias
    final remoteDataSource = SupabaseAuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);

    _viewModel = RegisterViewModel(authRepository: authRepository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.create_account'),
      subtitle: context.tr('shared.lorem'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RegisterEmailForm(viewModel: _viewModel),
          const Spacer(),
          const _RegisterFooterLink(),
          // Don't have an account link
        ],
      ),
    );
  }
}

class _RegisterEmailForm extends StatefulWidget {
  const _RegisterEmailForm({required this.viewModel});

  final RegisterViewModel viewModel;

  @override
  State<_RegisterEmailForm> createState() => _RegisterEmailFormState();
}

class _RegisterEmailFormState extends State<_RegisterEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      widget.viewModel.register(
        _emailController.text,
        _passwordController.text,
        onSuccess: () {
          // La Vista (UI) reacciona al éxito
          DSSuccessDialog.show(
            context,
            title: context.tr('auth.registration_successful_title'),
            subtitle: context.tr('auth.registration_successful_subtitle'),
            buttonText: context.tr('auth.login_button'),
            onPressed: () {
              // Cuando el usuario le da al botón, lo llevamos al login
              context.go(AppRoutes.login);
            },
          );
        },
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
        final isPassVisible = widget.viewModel.isPasswordVisible;
        final isConfirmVisible = widget.viewModel.isConfirmPasswordVisible;

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
                validator: (val) => AppValidators.validateEmail(context, val),
              ),

              DSTextFormField(
                controller: _passwordController,
                label: context.tr('auth.password'),
                hint: context.tr('auth.password_hint'),
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                obscureText: !isPassVisible,
                validator: (val) =>
                    AppValidators.validatePassword(context, val),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPassVisible
                        ? IconsaxPlusLinear.eye_slash
                        : IconsaxPlusLinear.eye,
                  ),
                  onPressed: widget.viewModel.togglePasswordVisibility,
                ),
              ),

              DSTextFormField(
                controller: _confirmPasswordController,
                label: context.tr('auth.confirm_password'),
                hint: context.tr('auth.password_hint'),
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                obscureText: !isConfirmVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmVisible
                        ? IconsaxPlusLinear.eye_slash
                        : IconsaxPlusLinear.eye,
                  ),
                  onPressed: widget.viewModel.toggleConfirmPasswordVisibility,
                ),
                validator: (val) => AppValidators.validateConfirmPassword(
                  context,
                  val,
                  _passwordController.text,
                ),
              ),

              DSRichText(
                text: context.tr('auth.terms_and_conditions'),
                fontWeight: TypographyTokens.fontWeightRegular,
                linkText: context.tr('auth.terms_and_conditions_details'),
                onLinkTap: () {},
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: SpacingTokens.spacing24,
                ),
                child: DSButton(
                  label: context.tr('auth.register'),
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submitForm,
                ),
              ),
            ],
          ),
        );
      },
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
