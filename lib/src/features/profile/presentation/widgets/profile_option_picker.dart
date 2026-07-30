import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

/// A single selectable option shown by [showProfileOptionPicker].
class ProfileOption<T> {
  final T value;
  final String label;

  const ProfileOption({required this.value, required this.label});
}

/// Presents a bottom sheet that lets the user pick one option from [options].
///
/// Returns the selected value, or `null` when the sheet is dismissed.
Future<T?> showProfileOptionPicker<T>({
  required BuildContext context,
  required String title,
  required List<ProfileOption<T>> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: context.dsColors.secondaryContainer,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(RadiusTokens.lg),
      ),
    ),
    builder: (context) => _ProfileOptionPickerSheet<T>(
      title: title,
      options: options,
      selected: selected,
    ),
  );
}

class _ProfileOptionPickerSheet<T> extends StatelessWidget {
  final String title;
  final List<ProfileOption<T>> options;
  final T? selected;

  const _ProfileOptionPickerSheet({
    required this.title,
    required this.options,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SpacingTokens.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
                vertical: SpacingTokens.spacing8,
              ),
              child: Text(
                title,
                style: context.dsTextTheme.bodyLarge?.copyWith(
                  color: context.dsColors.onSurface,
                  fontWeight: TypographyTokens.fontWeightBold,
                ),
              ),
            ),
            for (final option in options)
              ListTile(
                title: Text(
                  option.label,
                  style: context.dsTextTheme.bodyMedium?.copyWith(
                    color: context.dsColors.onSurface,
                  ),
                ),
                trailing: option.value == selected
                    ? Icon(Icons.check, color: context.dsColors.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(option.value),
              ),
          ],
        ),
      ),
    );
  }
}
