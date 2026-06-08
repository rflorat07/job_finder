import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

const double _kDsAppBarDefaultToolbarHeight = 64;

/// Design System app bar that standardizes title, leading, and actions slots.
class DSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final double elevation;
  final double? scrolledUnderElevation;
  final bool automaticallyImplyLeading;
  final double? toolbarHeight;
  final double? leadingWidth;
  final double horizontalPadding;
  final EdgeInsetsGeometry? actionsPadding;

  const DSAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleTextStyle,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
    this.automaticallyImplyLeading = false,
    this.toolbarHeight,
    this.leadingWidth,
    this.horizontalPadding = SpacingTokens.spacing24,
    this.actionsPadding,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight ?? _kDsAppBarDefaultToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final effectiveToolbarHeight =
        toolbarHeight ?? _kDsAppBarDefaultToolbarHeight;

    final resolvedLeading = leading != null
        ? Padding(
            padding: EdgeInsetsDirectional.only(start: horizontalPadding),
            child: Align(alignment: Alignment.centerLeft, child: leading),
          )
        : null;

    final resolvedLeadingWidth = leading != null
        ? (leadingWidth ?? (effectiveToolbarHeight + horizontalPadding))
        : leadingWidth;

    return AppBar(
      backgroundColor: backgroundColor ?? context.dsColors.primary,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      leading: resolvedLeading,
      leadingWidth: resolvedLeadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      actionsPadding:
          actionsPadding ?? EdgeInsetsDirectional.only(end: horizontalPadding),
      centerTitle: centerTitle,
      toolbarHeight: effectiveToolbarHeight,
      title: Text(
        title,
        style:
            titleTextStyle ??
            TypographyTokens.bodyLarge.copyWith(
              fontWeight: TypographyTokens.fontWeightBold,
              color: context.dsColors.onSurface,
              height: TypographyTokens.lineHeightTight,
            ),
      ),
    );
  }
}

@Preview(name: 'DSAppBar Preview - Light', brightness: Brightness.light)
Widget dsAppBarPreview() {
  return DsPreviewScaffold(
    children: [
      Scaffold(
        appBar: DSAppBar(
          title: 'Notifications',
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(PrimitiveColors.greyscale100),
            ),
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            TextButton(onPressed: () {}, child: const Text('Mark all')),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    ],
  );
}
