import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A circular icon button that supports both [IconData] and SVG assets.
///
/// Use the named factories to create the appropriate variant:
/// - [DSCircularIcon.icon] for Material [IconData].
/// - [DSCircularIcon.svg] for SVG asset paths.
class DSCircularIcon extends StatelessWidget {
  final IconData? _iconData;
  final String? _svgAsset;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  /// Private constructor.
  const DSCircularIcon._({
    super.key,
    IconData? iconData,
    String? svgAsset,
    required this.size,
    required this.iconSize,
    required this.backgroundColor,
    this.iconColor,
    this.onPressed,
  }) : _iconData = iconData,
       _svgAsset = svgAsset;

  /// Creates a circular icon from a Material [IconData].
  factory DSCircularIcon.icon(
    IconData iconData, {
    Key? key,
    double size = SizesTokens.size40,
    double iconSize = SizesTokens.size20,
    Color? iconColor,
    Color backgroundColor = const Color(0x33FFFFFF),
    VoidCallback? onPressed,
  }) {
    return DSCircularIcon._(
      key: key,
      iconData: iconData,
      size: size,
      iconSize: iconSize,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
    );
  }

  /// Creates a circular icon from an SVG asset path.
  factory DSCircularIcon.svg(
    String assetPath, {
    Key? key,
    double size = SizesTokens.size40,
    double iconSize = SizesTokens.size20,
    Color? iconColor,
    Color backgroundColor = const Color(0x33FFFFFF),
    VoidCallback? onPressed,
  }) {
    return DSCircularIcon._(
      key: key,
      svgAsset: assetPath,
      size: size,
      iconSize: iconSize,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = _iconData != null
        ? Icon(_iconData, size: iconSize, color: iconColor)
        : SvgPicture.asset(
            _svgAsset!,
            width: iconSize,
            height: iconSize,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
          );

    final container = DSRoundedContainer(
      width: size,
      height: size,
      borderRadius: RadiusTokens.fullRadius,
      backgroundColor: backgroundColor,
      child: Center(child: child),
    );

    if (onPressed == null) return container;

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: container,
    );
  }
}

@Preview(name: 'DSCircularIcon Preview', brightness: Brightness.light)
Widget dsCircularIconPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale800),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // IconData variant
          DSCircularIcon.icon(
            Icons.notifications_outlined,
            iconColor: Colors.white,
            backgroundColor: Colors.white.withAlpha(50),
            onPressed: () {},
          ),

          // SVG variant
          DSCircularIcon.svg(
            'assets/icons/apple.svg',
            iconColor: Colors.white,
            backgroundColor: Colors.white.withAlpha(50),
            onPressed: () {},
          ),
        ],
      ),
    ],
  );
}
