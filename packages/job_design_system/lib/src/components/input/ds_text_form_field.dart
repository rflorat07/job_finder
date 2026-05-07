import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSTextFormField extends StatelessWidget {
  const DSTextFormField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.autofocus = false,
    this.autovalidateMode,
  });

  ///  Label text displayed above the input field
  final String? label;

  /// Hint text displayed inside the input when it's empty
  final String? hint;

  /// Controller for managing the text input's value
  final TextEditingController? controller;

  /// Validator function for validating the input value
  final FormFieldValidator<String>? validator;

  /// Callback function called when the input value changes
  final ValueChanged<String>? onChanged;

  /// Callback function called when the input field is submitted
  final ValueChanged<String>? onFieldSubmitted;

  /// Focus node for managing the input field's focus
  final FocusNode? focusNode;

  /// Keyboard type for the input field
  final TextInputType? keyboardType;

  /// Text input action for the input field
  final TextInputAction? textInputAction;

  /// Whether the input field should obscure the text
  final bool obscureText;

  /// Whether the input field is read-only
  final bool readOnly;

  /// Whether the input field is enabled
  final bool enabled;

  /// Maximum number of lines for the input field
  final int? maxLines;

  /// Minimum number of lines for the input field
  final int? minLines;

  /// Widget displayed at the start of the input field
  final Widget? prefixIcon;

  /// Widget displayed at the end of the input field
  final Widget? suffixIcon;

  /// Initial value for the input field
  final String? initialValue;

  /// Whether the input field should autofocus
  final bool autofocus;

  /// Autovalidate mode for the input field
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;
    final dsTextTheme = context.dsTextTheme;

    return Column(
      spacing: SpacingTokens.spacing6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: dsTextTheme.bodySmall?.copyWith(
              color: dsColors.onSurface,
              height: TypographyTokens.lineHeightExtraRelaxed,
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          autofocus: autofocus,
          style: dsTextTheme.bodyMedium?.copyWith(
            height: TypographyTokens.lineHeightInput,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: dsColors.primary,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}

@Preview(name: 'DSTextFormField Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSTextFormField Preview - Dark', brightness: Brightness.dark)
Widget textFormFieldLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [DSTextFormField(label: 'Label', hint: 'Hint')],
      ),
    ],
  );
}
