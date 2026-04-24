import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSDivider extends StatelessWidget {
  const DSDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing16,
          ),
          child: Text(
            label,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: context.dsColors.secondary,
              fontWeight: TypographyTokens.fontWeightRegular,
              height: TypographyTokens.lineHeightExtraRelaxed,
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}

@Preview(name: 'DSDivider Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSSocialButton Preview - Dark', brightness: Brightness.dark)
Widget dividerLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [DSDivider(label: 'Or continue with')],
      ),
    ],
  );
}
