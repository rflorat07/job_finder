import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

/// Screen that lets the user edit the "About Me" section of their profile.
class AboutMeScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const AboutMeScreen({super.key, required this.viewModel});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _aboutMeController;

  @override
  void initState() {
    super.initState();
    _aboutMeController = TextEditingController(
      text: widget.viewModel.profile?.aboutMe ?? '',
    );
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();

    final text = _aboutMeController.text.trim();
    final success = await widget.viewModel.saveAboutMe(
      text.isEmpty ? null : text,
    );

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
            title: context.tr('profile.about_me_title'),
            saveLabel: context.tr('profile.save'),
            isSaving: widget.viewModel.isSaving,
            onSave: _onSave,
            children: [
              Text(
                context.tr('profile.about_me_title'),
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onSurface,
                  height: TypographyTokens.lineHeightExtraRelaxed,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing4),
              Text(
                context.tr('profile.about_me_description'),
                style: context.dsTextTheme.bodySmall?.copyWith(
                  color: context.dsColors.onSurfaceVariant,
                  fontWeight: TypographyTokens.fontWeightRegular,
                  height: TypographyTokens.lineHeightExtraRelaxed,
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing24),

              DSTextFormField(
                label: context.tr('profile.cover_letter'),
                hint: context.tr('profile.cover_letter_hint'),
                controller: _aboutMeController,
                maxLines: 8,
                minLines: 6,
                keyboardType: TextInputType.multiline,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onPrimaryContainer,
                  fontWeight: TypographyTokens.fontWeightRegular,
                  height: TypographyTokens.lineHeightInput,
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? context.tr('profile.cover_letter_required')
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
