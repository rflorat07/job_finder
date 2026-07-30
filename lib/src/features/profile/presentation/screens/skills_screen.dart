import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

/// Screen that lets the user manage the skills they've mastered.
class SkillsScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const SkillsScreen({super.key, required this.viewModel});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  late List<String> _skills;

  @override
  void initState() {
    super.initState();
    _skills = List<String>.from(widget.viewModel.profile?.skills ?? const []);
  }

  Future<void> _addSkill() async {
    final skill = await _showAddSkillDialog();
    if (skill == null || !mounted) {
      return;
    }

    final trimmed = skill.trim();
    final alreadyExists = _skills.any(
      (existing) => existing.toLowerCase() == trimmed.toLowerCase(),
    );
    if (trimmed.isEmpty || alreadyExists) {
      return;
    }

    setState(() => _skills.add(trimmed));
  }

  void _removeSkill(String skill) {
    setState(() => _skills.remove(skill));
  }

  Future<String?> _showAddSkillDialog() {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => const _AddSkillDialog(),
    );
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final success = await widget.viewModel.saveSkills(_skills);

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
        return ProfileEditScaffold(
          title: context.tr('profile.skills_title'),
          saveLabel: context.tr('profile.save'),
          isSaving: widget.viewModel.isSaving,
          onSave: _onSave,
          action: TextButton(
            onPressed: _addSkill,
            child: Text(
              context.tr('profile.add_skills'),
              style: context.dsTextTheme.bodyMedium?.copyWith(
                color: context.dsColors.primary,
                fontWeight: TypographyTokens.fontWeightSemiBold,
              ),
            ),
          ),
          children: [
            Text(
              context.tr('profile.skills_mastered'),
              style: context.dsTextTheme.bodyMedium?.copyWith(
                color: context.dsColors.onSurface,
                fontWeight: TypographyTokens.fontWeightSemiBold,
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing16),
            if (_skills.isEmpty)
              Text(
                context.tr('profile.skills_empty'),
                style: context.dsTextTheme.bodySmall?.copyWith(
                  color: context.dsColors.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: SpacingTokens.spacing8,
                runSpacing: SpacingTokens.spacing8,
                children: [
                  for (final skill in _skills)
                    _SkillChip(
                      label: skill,
                      onRemove: () => _removeSkill(skill),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// Dialog that owns its own [TextEditingController] and lets the user type a
/// new skill. Returns the entered text on confirm, or `null` on cancel.
class _AddSkillDialog extends StatefulWidget {
  const _AddSkillDialog();

  @override
  State<_AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<_AddSkillDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.dsColors.secondaryContainer,
      title: Text(
        context.tr('profile.add_skill'),
        style: context.dsTextTheme.bodyLarge?.copyWith(
          fontWeight: TypographyTokens.fontWeightBold,
        ),
      ),
      content: DSTextFormField(
        hint: context.tr('profile.skill_hint'),
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('profile.cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(context.tr('profile.add')),
        ),
      ],
    );
  }
}

/// A removable skill chip rendered inside the skills grid.
class _SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SkillChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing12,
        vertical: SpacingTokens.spacing8,
      ),
      decoration: BoxDecoration(
        color: context.dsColors.primaryContainer,
        borderRadius: BorderRadius.circular(RadiusTokens.full),
        border: Border.all(color: context.dsColors.primary.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: context.dsColors.primary,
              fontWeight: TypographyTokens.fontWeightSemiBold,
            ),
          ),
          const SizedBox(width: SpacingTokens.spacing6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              IconsaxPlusLinear.close_circle,
              size: SizesTokens.size16,
              color: context.dsColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
