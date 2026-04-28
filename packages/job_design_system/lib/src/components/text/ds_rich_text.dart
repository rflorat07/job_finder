import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

class DSRichText extends StatelessWidget {
  const DSRichText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkTap,
    this.fontWeight,
  });

  ///  Main text content
  final String text;

  ///  Link text that is tappable
  final String linkText;

  ///  Callback when the link text is tapped
  final VoidCallback onLinkTap;

  ///  Optional font weight for the link text
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: context.dsTextTheme.bodySmall?.copyWith(
          color: context.dsColors.secondary,
          fontWeight: TypographyTokens.fontWeightRegular,
          height: TypographyTokens.lineHeightExtraRelaxed,
        ),
        children: [
          TextSpan(
            text: linkText,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: context.dsColors.primary,
              height: TypographyTokens.lineHeightExtraRelaxed,
              fontWeight: fontWeight,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'DSRichText Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSRichText Preview - Dark', brightness: Brightness.dark)
Widget dsRichTextLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DSRichText(
            text: 'Main text ',
            linkText: ' Link text ',
            onLinkTap: () {},
          ),
        ],
      ),
    ],
  );
}
