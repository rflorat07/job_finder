import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSSuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const DSSuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DSSuccessDialog(
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.xl2),
      ),
      backgroundColor: context.dsColors.secondaryContainer,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing24,
          vertical: SpacingTokens.spacing32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(PrimitiveColors.primary500),
                  width: 2,
                ),
                color: Color(PrimitiveColors.primary500).withAlpha(25),
              ),
              child: const Icon(
                Icons.check,
                color: Color(PrimitiveColors.primary500),
                size: 40,
              ),
            ),

            const SizedBox(height: SpacingTokens.spacing32),

            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: TypographyTokens.fontWeightBold,
                color: context.dsColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: SpacingTokens.spacing8),

            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Color(PrimitiveColors.greyscale400),
                height: TypographyTokens.lineHeightRelaxed,
                fontWeight: TypographyTokens.fontWeightRegular,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: SpacingTokens.spacing32),

            DSButton(
              label: buttonText,
              size: DSButtonSize.medium,
              onPressed: () {
                Navigator.of(context).pop();
                onPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'DSSuccessDialog Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSSuccessDialog Preview - Dark', brightness: Brightness.dark)
Widget dsSuccessDialogLightDarkPreview() {
  return MaterialApp(
    theme: DSThemeLight.build(),
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Builder(
          builder: (context) {
            return Column(
              spacing: SpacingTokens.spacing16,
              mainAxisSize: MainAxisSize.min,
              children: [
                DSButton(
                  label: 'Show Success Dialog',
                  onPressed: () => DSSuccessDialog.show(
                    context,
                    title: 'Success!',
                    subtitle: 'This is a success message!',
                    buttonText: 'OK',
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
