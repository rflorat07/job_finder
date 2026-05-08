import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:pinput/pinput.dart';

import '../../../job_design_system.dart';
// import de tus tokens

class DSOtpInput extends StatelessWidget {
  const DSOtpInput({
    super.key,
    required this.controller,
    this.validator,
    this.length = 5,
    this.onCompleted,
  });

  final int length;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: Sizes.size52,
      height: Sizes.size48,
      textStyle: context.dsTextTheme.headlineMedium?.copyWith(
        color: context.dsColors.onSurface,
        fontWeight: TypographyTokens.fontWeightMedium,
      ),
      decoration: BoxDecoration(
        color: context.dsColors.surface,
        borderRadius: BorderRadius.circular(RadiusTokens.xsm),
        border: Border.all(color: context.dsColors.outline),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: context.dsColors.primary),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: context.dsColors.error),
      ),
    );

    return Pinput(
      length: length,
      controller: controller,

      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      errorPinTheme: errorPinTheme,

      validator: validator,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,

      autofillHints: const [AutofillHints.oneTimeCode],

      onCompleted: onCompleted,
    );
  }
}

@Preview(name: 'DSOtpInput Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSOtpInput Preview - Dark', brightness: Brightness.dark)
Widget otpInputLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSOtpInput(
            controller: TextEditingController(),
            validator: (val) {
              if (val == null || val.length < 5) {
                return 'Please enter a valid 5-digit code';
              }
              return null;
            },
          ),
        ],
      ),
    ],
  );
}
