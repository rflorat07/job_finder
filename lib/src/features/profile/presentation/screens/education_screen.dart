import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

/// Screen that lets the user edit the education section of their profile.
class EducationScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const EducationScreen({super.key, required this.viewModel});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _levelController = TextEditingController();
  final _schoolController = TextEditingController();
  final _studyProgramController = TextEditingController();
  final _startController = TextEditingController();
  final _graduateController = TextEditingController();
  final _organizationalController = TextEditingController();

  EducationLevel? _educationLevel;
  DateTime? _educationStart;
  DateTime? _graduateEducation;

  @override
  void initState() {
    super.initState();
    final profile = widget.viewModel.profile;
    _educationLevel = profile?.educationLevel;
    _schoolController.text = profile?.school ?? '';
    _studyProgramController.text = profile?.studyProgram ?? '';
    _organizationalController.text = profile?.organizationalExperience ?? '';
    _educationStart = profile?.educationStart;
    _graduateEducation = profile?.graduateEducation;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_educationLevel != null) {
      _levelController.text = _educationLevelLabel(_educationLevel!);
    }
    if (_educationStart != null) {
      _startController.text = _formatDate(_educationStart!);
    }
    if (_graduateEducation != null) {
      _graduateController.text = _formatDate(_graduateEducation!);
    }
  }

  @override
  void dispose() {
    _levelController.dispose();
    _schoolController.dispose();
    _studyProgramController.dispose();
    _startController.dispose();
    _graduateController.dispose();
    _organizationalController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      MaterialLocalizations.of(context).formatMediumDate(date);

  String _educationLevelLabel(EducationLevel level) => switch (level) {
    EducationLevel.highSchool => context.tr('profile.education_high_school'),
    EducationLevel.associate => context.tr('profile.education_associate'),
    EducationLevel.bachelor => context.tr('profile.education_bachelor'),
    EducationLevel.master => context.tr('profile.education_master'),
    EducationLevel.doctorate => context.tr('profile.education_doctorate'),
    EducationLevel.other => context.tr('profile.education_other'),
  };

  Future<void> _pickEducationLevel() async {
    final selected = await showProfileOptionPicker<EducationLevel>(
      context: context,
      title: context.tr('profile.education_level'),
      selected: _educationLevel,
      options: [
        for (final level in EducationLevel.values)
          ProfileOption(value: level, label: _educationLevelLabel(level)),
      ],
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _educationLevel = selected;
      _levelController.text = _educationLevelLabel(selected);
    });
  }

  Future<void> _pickDate({
    required DateTime? current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null || !mounted) {
      return;
    }
    onPicked(picked);
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();

    final success = await widget.viewModel.saveEducation(
      educationLevel: _educationLevel,
      school: _nullIfEmpty(_schoolController.text),
      studyProgram: _nullIfEmpty(_studyProgramController.text),
      educationStart: _educationStart,
      graduateEducation: _graduateEducation,
      organizationalExperience: _nullIfEmpty(_organizationalController.text),
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
            title: context.tr('profile.education_title'),
            saveLabel: context.tr('profile.save'),
            isSaving: widget.viewModel.isSaving,
            onSave: _onSave,
            children: [
              ProfilePickerField(
                label: context.tr('profile.education_level'),
                hint: context.tr('profile.select_placeholder'),
                controller: _levelController,
                onTap: _pickEducationLevel,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSTextFormField(
                label: context.tr('profile.school'),
                hint: context.tr('profile.school_hint'),
                controller: _schoolController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSTextFormField(
                label: context.tr('profile.study_program'),
                hint: context.tr('profile.study_program_hint'),
                controller: _studyProgramController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              ProfilePickerField(
                label: context.tr('profile.education_start'),
                hint: context.tr('profile.select_placeholder'),
                controller: _startController,
                suffixIcon: const Icon(IconsaxPlusLinear.calendar),
                onTap: () => _pickDate(
                  current: _educationStart,
                  onPicked: (date) => setState(() {
                    _educationStart = date;
                    _startController.text = _formatDate(date);
                  }),
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              ProfilePickerField(
                label: context.tr('profile.graduate_education'),
                hint: context.tr('profile.select_placeholder'),
                controller: _graduateController,
                suffixIcon: const Icon(IconsaxPlusLinear.calendar),
                onTap: () => _pickDate(
                  current: _graduateEducation,
                  onPicked: (date) => setState(() {
                    _graduateEducation = date;
                    _graduateController.text = _formatDate(date);
                  }),
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSTextFormField(
                label: context.tr('profile.organizational_experience'),
                hint: context.tr('profile.organizational_experience_hint'),
                controller: _organizationalController,
                maxLines: 5,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onPrimaryContainer,
                  fontWeight: TypographyTokens.fontWeightRegular,
                  height: TypographyTokens.lineHeightInput,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
