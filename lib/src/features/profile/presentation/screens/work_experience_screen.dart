import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

/// Screen that lets the user edit the work experience section of their profile.
class WorkExperienceScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const WorkExperienceScreen({super.key, required this.viewModel});

  @override
  State<WorkExperienceScreen> createState() => _WorkExperienceScreenState();
}

class _WorkExperienceScreenState extends State<WorkExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _contractController = TextEditingController();
  final _jobNameController = TextEditingController();
  final _fieldOfWorkController = TextEditingController();
  final _descriptionController = TextEditingController();

  ContractType? _contractType;

  @override
  void initState() {
    super.initState();
    final profile = widget.viewModel.profile;
    _companyController.text = profile?.companyName ?? '';
    _jobNameController.text = profile?.jobName ?? '';
    _fieldOfWorkController.text = profile?.fieldOfWork ?? '';
    _descriptionController.text = profile?.jobDescription ?? '';
    _contractType = profile?.contractType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_contractType != null) {
      _contractController.text = _contractTypeLabel(_contractType!);
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contractController.dispose();
    _jobNameController.dispose();
    _fieldOfWorkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _contractTypeLabel(ContractType type) => switch (type) {
    ContractType.fullTime => context.tr('profile.contract_full_time'),
    ContractType.partTime => context.tr('profile.contract_part_time'),
    ContractType.contract => context.tr('profile.contract_contract'),
    ContractType.internship => context.tr('profile.contract_internship'),
    ContractType.freelance => context.tr('profile.contract_freelance'),
  };

  Future<void> _pickContractType() async {
    final selected = await showProfileOptionPicker<ContractType>(
      context: context,
      title: context.tr('profile.contract_type'),
      selected: _contractType,
      options: [
        for (final type in ContractType.values)
          ProfileOption(value: type, label: _contractTypeLabel(type)),
      ],
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _contractType = selected;
      _contractController.text = _contractTypeLabel(selected);
    });
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();

    final success = await widget.viewModel.saveWorkExperience(
      companyName: _nullIfEmpty(_companyController.text),
      contractType: _contractType,
      jobName: _nullIfEmpty(_jobNameController.text),
      fieldOfWork: _nullIfEmpty(_fieldOfWorkController.text),
      jobDescription: _nullIfEmpty(_descriptionController.text),
    );

    if (!mounted) {
      return;
    }
    _showResult(success);
    if (success && context.canPop()) {
      context.pop();
    }
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
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
            title: context.tr('profile.work_experience_title'),
            saveLabel: context.tr('profile.save'),
            isSaving: widget.viewModel.isSaving,
            onSave: _onSave,
            children: [
              DSTextFormField(
                label: context.tr('profile.company_name'),
                hint: context.tr('profile.company_name_hint'),
                controller: _companyController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              ProfilePickerField(
                label: context.tr('profile.contract_type'),
                hint: context.tr('profile.select_placeholder'),
                controller: _contractController,
                onTap: _pickContractType,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSTextFormField(
                label: context.tr('profile.job_name'),
                hint: context.tr('profile.job_name_hint'),
                controller: _jobNameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSTextFormField(
                label: context.tr('profile.field_of_work'),
                hint: context.tr('profile.field_of_work_hint'),
                controller: _fieldOfWorkController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSTextFormField(
                label: context.tr('profile.job_description'),
                hint: context.tr('profile.job_description_hint'),
                controller: _descriptionController,
                maxLines: 6,
                minLines: 4,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        );
      },
    );
  }
}
