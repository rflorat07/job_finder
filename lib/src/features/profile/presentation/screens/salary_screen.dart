import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

/// Screen that lets the user set their minimum expected monthly salary.
class SalaryScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const SalaryScreen({super.key, required this.viewModel});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _salaryController;

  @override
  void initState() {
    super.initState();
    final salary = widget.viewModel.profile?.minimumSalary;
    _salaryController = TextEditingController(
      text: salary != null ? salary.toString() : '',
    );
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();

    final raw = _salaryController.text.trim();
    final salary = raw.isEmpty ? null : int.tryParse(raw);

    final success = await widget.viewModel.saveSalary(salary);

    if (!mounted) {
      return;
    }
    _showResult(success);
    if (success && context.canPop()) {
      context.pop();
    }
  }

  void _showResult(bool success) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? context.tr('profile.saved_success')
              : widget.viewModel.errorMessage ??
                    context.tr('profile.generic_error'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Form(
          key: _formKey,
          child: ProfileEditScaffold(
            title: context.tr('profile.salary_title'),
            saveLabel: context.tr('profile.save'),
            isSaving: widget.viewModel.isSaving,
            onSave: _onSave,
            children: [
              Text(
                context.tr('profile.salary_description'),
                style: context.dsTextTheme.bodySmall?.copyWith(
                  color: context.dsColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing24),
              DSTextFormField(
                label: context.tr('profile.minimum_salary'),
                hint: context.tr('profile.minimum_salary_hint'),
                controller: _salaryController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(IconsaxPlusLinear.dollar_circle),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return int.tryParse(value.trim()) == null
                      ? context.tr('profile.minimum_salary_invalid')
                      : null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
