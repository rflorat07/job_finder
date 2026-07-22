import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// An editable, rounded search input with a leading icon.
///
/// Unlike [DSSearchBar] (a tap-only navigation trigger), this is a real
/// text field that reports changes via [onChanged], ideal for live filtering.
class DSSearchField extends StatelessWidget {
  /// Placeholder text shown when empty.
  final String hintText;

  /// Called every time the query changes.
  final ValueChanged<String>? onChanged;

  /// Optional controller for the text value.
  final TextEditingController? controller;

  /// Leading icon.
  final IconData icon;

  /// Background color of the field.
  final Color? backgroundColor;

  const DSSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.icon = Icons.search,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final hintColor = context.dsColors.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.dsColors.secondaryContainer,
        borderRadius: RadiusTokens.fullRadius,
      ),
      child: Row(
        spacing: SpacingTokens.spacing16,
        children: [
          Icon(icon, color: hintColor, size: SizesTokens.size24),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              cursorColor: context.dsColors.primary,
              style: context.dsTextTheme.bodySmall?.copyWith(
                color: context.dsColors.onSurface,
                fontWeight: TypographyTokens.fontWeightRegular,
                height: TypographyTokens.lineHeightExtraRelaxed,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: SpacingTokens.spacing14,
                ),
                hintText: hintText,
                hintStyle: context.dsTextTheme.bodySmall?.copyWith(
                  color: hintColor,
                  fontWeight: TypographyTokens.fontWeightRegular,
                  height: TypographyTokens.lineHeightExtraRelaxed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'DSSearchField Preview - Light', brightness: Brightness.light)
Widget dsSearchFieldPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [DSSearchField(hintText: 'Search name or message')],
  );
}
