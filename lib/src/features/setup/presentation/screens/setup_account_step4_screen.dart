import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';

class SetupAccountStep4Screen extends StatefulWidget {
  final SetupAccountViewModel viewModel;

  const SetupAccountStep4Screen({
    super.key,
    required this.viewModel,
  });

  @override
  State<SetupAccountStep4Screen> createState() =>
      _SetupAccountStep4ScreenState();
}

class _SetupAccountStep4ScreenState extends State<SetupAccountStep4Screen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.viewModel.fullName;
    _usernameController.text = widget.viewModel.username;
    _bioController.text = widget.viewModel.bio;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onFinish() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    await widget.viewModel.completeSetup();

    setupCompletedCache = true;

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _onPickImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked != null) {
      widget.viewModel.updateProfileImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return DSSetupAccountBaseLayout(
          currentStep: 4,
          totalSteps: widget.viewModel.totalSteps,
          onPressed: () => context.canPop() ? context.pop() : null,
          title: context.tr('setup_account.complete_profile'),
          subtitle: context.tr('setup_account.complete_profile_subtitle'),
          bottomAction: DSButton(
            isLoading: _isSubmitting,
            onPressed: widget.viewModel.isStep4Valid ? _onFinish : null,
            label: context.tr('setup_account.finish'),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: SpacingTokens.spacing16,
            children: [
              Center(
                child: DSAvatarPicker(
                  imageFile: widget.viewModel.profileImage,
                  onPickImage: _onPickImage,
                ),
              ),
              DSTextFormField(
                controller: _fullNameController,
                label: context.tr('setup_account.full_name'),
                hint: context.tr('setup_account.full_name_hint'),
                onChanged: widget.viewModel.updateFullName,
              ),
              DSTextFormField(
                controller: _usernameController,
                label: context.tr('setup_account.username'),
                hint: context.tr('setup_account.username_hint'),
                onChanged: widget.viewModel.updateUsername,
                keyboardType: TextInputType.name,
              ),
              DSTextFormField(
                controller: _bioController,
                label: context.tr('setup_account.bio'),
                hint: context.tr('setup_account.bio_hint'),
                onChanged: widget.viewModel.updateBio,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        );
      },
    );
  }
}
