import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSAuthBaseLayout(
      title: context.tr('auth.forgot_password_title'),
      showBackButton: true,
      icon: IconsaxPlusLinear.arrow_left_1,
      onPressed: () => context.go(AppRoutes.login),
      child: const Column(
        spacing: SpacingTokens.spacing24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NewPasswordHeader(),
          _NewPasswordForm(),
        ],
      ),
    );
  }
}

class _NewPasswordHeader extends StatelessWidget {
  const _NewPasswordHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SpacingTokens.spacing4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('auth.create_new_password'),
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
    );
  }
}

class _NewPasswordForm extends StatefulWidget {
  const _NewPasswordForm();

  @override
  State<_NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<_NewPasswordForm> {
  late final NewPasswordViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = NewPasswordViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      _viewModel.updatePassword(
        _passwordController.text,
        onSuccess: () {
          DSToast.showSuccess(
            context: context,
            message: 'Password updated successfully!',
          );
          context.go(AppRoutes.login);
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
      listenable: _viewModel,
      builder: (context, _) {
        final isLoading = _viewModel.isLoading;
        final isPassVisible = _viewModel.isPasswordVisible;
        final isConfirmVisible = _viewModel.isConfirmPasswordVisible;

        return Expanded(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: SpacingTokens.spacing16,
              children: [
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
                    onPressed: _viewModel.togglePasswordVisibility,
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
                    onPressed: _viewModel.toggleConfirmPasswordVisibility,
                  ),
                  validator: (val) => AppValidators.validateConfirmPassword(
                    context,
                    val,
                    _passwordController.text,
                  ),
                ),

                const Spacer(),

                DSButton(
                  label: context.tr('shared.submit'),
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submitForm,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
