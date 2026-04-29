import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

class DSRoundedContainer extends StatelessWidget {
  const DSRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.child,
    this.backgroundColor = SemanticColorsLight.primary,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  // Optional width for flexibility,
  final double? width;

  // Optional height for flexibility,
  final double? height;

  // Default background color
  final Color? backgroundColor;

  // Optional border radius defaults to 16px if not provided
  final BorderRadius? borderRadius;

  // Optional child widget
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

@Preview(
  name: 'DSRoundedContainer Preview - Light',
  brightness: Brightness.light,
)
//@Preview(name: 'DSRoundedContainer Preview - Dark', brightness: Brightness.dark)
Widget roundedContainerLightDarkPreview() {
  return DsPreviewScaffold(
    children: [
      Column(
        spacing: SpacingTokens.spacing16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [DSRoundedContainer()],
      ),
    ],
  );
}
