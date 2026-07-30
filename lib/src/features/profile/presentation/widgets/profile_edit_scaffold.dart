import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

/// Standard scaffold shared by every profile edit sub-screen.
///
/// Renders a centered [DSAppBar] with a back button, a scrollable form body
/// and a pinned primary [DSButton] at the bottom.
class ProfileEditScaffold extends StatelessWidget {
  final String title;
  final String saveLabel;
  final bool isSaving;
  final VoidCallback? onSave;
  final List<Widget> children;

  /// Optional trailing widget rendered in the app bar (e.g. "Add Skills").
  final Widget? action;

  const ProfileEditScaffold({
    super.key,
    required this.title,
    required this.saveLabel,
    required this.isSaving,
    required this.onSave,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: title,
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
        actions: action != null ? [action!] : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.spacing24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              DSButton(
                width: double.infinity,
                isLoading: isSaving,
                onPressed: isSaving ? null : onSave,
                label: saveLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
