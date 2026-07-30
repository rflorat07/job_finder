import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';

/// Screen that lets the user view and edit their personal data.
class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  late final PersonalDataViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  final _currentAddressController = TextEditingController();

  DateTime? _dateOfBirth;
  Gender? _gender;
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();

    final datasource = SupabasePersonalDataRemoteDataSource(
      Supabase.instance.client,
    );
    final repository = PersonalDataRepositoryImpl(datasource);
    _viewModel = PersonalDataViewModel(repository);
    _viewModel.addListener(_hydrateFromViewModel);
    _viewModel.loadPersonalData();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_hydrateFromViewModel);
    _viewModel.dispose();
    _fullNameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _currentAddressController.dispose();
    super.dispose();
  }

  /// Fills the form controllers once, the first time data is available.
  void _hydrateFromViewModel() {
    final data = _viewModel.data;
    if (_hydrated || data == null || !mounted) {
      return;
    }
    _hydrated = true;

    _fullNameController.text = data.fullName;
    _nicknameController.text = data.nickname ?? '';
    _phoneController.text = data.phoneNumber ?? '';
    _emailController.text = data.email;
    _currentAddressController.text = data.currentAddress ?? '';
    _dateOfBirth = data.dateOfBirth;
    _gender = data.gender;

    if (data.dateOfBirth != null) {
      _dateOfBirthController.text = _formatDate(data.dateOfBirth!);
    }
    if (data.gender != null) {
      _genderController.text = _genderLabel(data.gender!);
    }
  }

  String _formatDate(DateTime date) =>
      MaterialLocalizations.of(context).formatMediumDate(date);

  String _genderLabel(Gender gender) => switch (gender) {
    Gender.male => context.tr('personal_data.gender_male'),
    Gender.female => context.tr('personal_data.gender_female'),
    Gender.other => context.tr('personal_data.gender_other'),
  };

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate =
        _dateOfBirth ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _dateOfBirth = picked;
      _dateOfBirthController.text = _formatDate(picked);
    });
  }

  Future<void> _pickGender() async {
    final selected = await showModalBottomSheet<Gender>(
      context: context,
      backgroundColor: context.dsColors.secondaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.lg),
        ),
      ),
      builder: (context) => _GenderPickerSheet(selected: _gender),
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _gender = selected;
      _genderController.text = _genderLabel(selected);
    });
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();
    final nickname = _nicknameController.text.trim();
    final currentAddress = _currentAddressController.text.trim();

    final success = await _viewModel.save(
      fullName: _fullNameController.text.trim(),
      nickname: nickname.isEmpty ? null : nickname,
      phoneNumber: phone.isEmpty ? null : phone,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      currentAddress: currentAddress.isEmpty ? null : currentAddress,
    );

    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? context.tr('personal_data.saved_success')
              : _viewModel.errorMessage ??
                    context.tr('personal_data.generic_error'),
        ),
      ),
    );

    if (success && context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('personal_data.title'),
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            PersonalDataState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            PersonalDataState.error => _PersonalDataErrorState(
              message: _viewModel.errorMessage,
              onRetry: _viewModel.loadPersonalData,
            ),
            PersonalDataState.loaded ||
            PersonalDataState.saving => _buildForm(context),
          };
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final isSaving = _viewModel.state == PersonalDataState.saving;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.spacing24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: _ProfileAvatar(
                          avatarUrl: _viewModel.data?.avatarUrl,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.spacing24),

                      DSTextFormField(
                        label: context.tr('personal_data.full_name'),
                        hint: context.tr('personal_data.full_name_hint'),
                        controller: _fullNameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? context.tr('personal_data.full_name_required')
                            : null,
                      ),
                      const SizedBox(height: SpacingTokens.spacing16),

                      DSTextFormField(
                        label: context.tr('personal_data.nickname'),
                        hint: context.tr('personal_data.nickname_hint'),
                        controller: _nicknameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: SpacingTokens.spacing16),

                      DSTextFormField(
                        label: context.tr('personal_data.phone_number'),
                        hint: context.tr('personal_data.phone_number_hint'),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(IconsaxPlusLinear.call),
                      ),
                      const SizedBox(height: SpacingTokens.spacing16),

                      DSTextFormField(
                        label: context.tr('personal_data.email'),
                        controller: _emailController,
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(IconsaxPlusLinear.sms),
                      ),
                      const SizedBox(height: SpacingTokens.spacing16),

                      GestureDetector(
                        onTap: _pickDateOfBirth,
                        child: AbsorbPointer(
                          child: DSTextFormField(
                            label: context.tr('personal_data.date_of_birth'),
                            hint: context.tr(
                              'personal_data.date_of_birth_hint',
                            ),
                            controller: _dateOfBirthController,
                            readOnly: true,
                            suffixIcon: const Icon(IconsaxPlusLinear.calendar),
                          ),
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.spacing16),

                      GestureDetector(
                        onTap: _pickGender,
                        child: AbsorbPointer(
                          child: DSTextFormField(
                            label: context.tr('personal_data.gender'),
                            hint: context.tr('personal_data.gender_hint'),
                            controller: _genderController,
                            readOnly: true,
                            suffixIcon: const Icon(
                              IconsaxPlusLinear.arrow_down_1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.spacing16),

                      DSTextFormField(
                        label: context.tr('personal_data.current_address'),
                        hint: context.tr('personal_data.current_address_hint'),
                        controller: _currentAddressController,
                        maxLines: 3,
                        minLines: 1,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.newline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            DSButton(
              width: double.infinity,
              isLoading: isSaving,
              onPressed: isSaving ? null : _onSave,
              label: context.tr('personal_data.save_changes'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular avatar preview shown at the top of the form.
class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _ProfileAvatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return SizedBox(
      width: SizesTokens.size96,
      height: SizesTokens.size96,
      child: CircleAvatar(
        radius: SizesTokens.size48,
        backgroundColor: context.dsColors.secondaryContainer,
        backgroundImage: hasAvatar
            ? CachedNetworkImageProvider(avatarUrl!)
            : null,
        child: hasAvatar
            ? null
            : Icon(
                IconsaxPlusLinear.user,
                size: SizesTokens.size48,
                color: context.dsColors.onSurfaceVariant,
              ),
      ),
    );
  }
}

/// Bottom sheet that lets the user pick a [Gender].
class _GenderPickerSheet extends StatelessWidget {
  final Gender? selected;

  const _GenderPickerSheet({required this.selected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: SpacingTokens.spacing16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
                vertical: SpacingTokens.spacing8,
              ),
              child: Row(
                children: [
                  Text(
                    context.tr('personal_data.select_gender'),
                    style: context.dsTextTheme.bodyLarge?.copyWith(
                      color: context.dsColors.onSurface,
                      fontWeight: TypographyTokens.fontWeightBold,
                    ),
                  ),
                ],
              ),
            ),
            for (final gender in Gender.values)
              ListTile(
                title: Text(
                  switch (gender) {
                    Gender.male => context.tr('personal_data.gender_male'),
                    Gender.female => context.tr('personal_data.gender_female'),
                    Gender.other => context.tr('personal_data.gender_other'),
                  },
                  style: context.dsTextTheme.bodyMedium?.copyWith(
                    color: context.dsColors.onSurface,
                  ),
                ),
                trailing: gender == selected
                    ? Icon(Icons.check, color: context.dsColors.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(gender),
              ),
          ],
        ),
      ),
    );
  }
}

/// Error state with a retry action.
class _PersonalDataErrorState extends StatelessWidget {
  final String? message;
  final Future<void> Function() onRetry;

  const _PersonalDataErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? context.tr('personal_data.generic_error'),
              textAlign: TextAlign.center,
              style: context.dsTextTheme.bodyLarge,
            ),
            const SizedBox(height: SpacingTokens.spacing16),
            DSButton(
              label: context.tr('home.retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
