import 'package:job_design_system/job_design_system.dart';

import '../../../../imports/imports.dart';

/// A read-only [DSTextFormField] that opens a picker (dropdown or date) when
/// tapped. The displayed value is driven by the parent-owned [controller].
class ProfilePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final VoidCallback onTap;

  const ProfilePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: DSTextFormField(
          label: label,
          hint: hint,
          readOnly: true,
          controller: controller,
          suffixIcon: suffixIcon ?? const Icon(IconsaxPlusLinear.arrow_down),
        ),
      ),
    );
  }
}
