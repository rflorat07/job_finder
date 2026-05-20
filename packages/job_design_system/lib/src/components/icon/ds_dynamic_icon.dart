import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

enum DSIconType { svgAsset, iconData, network }

class DSDynamicIcon extends StatelessWidget {
  final String? assetOrUrl;
  final IconData? iconData;
  final DSIconType type;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  /// Private constructor
  const DSDynamicIcon._({
    required this.type,
    required this.size,
    this.assetOrUrl,
    this.iconData,
    this.color,
    this.backgroundColor,
  });

  /// Factory for vector (SVG) assets
  factory DSDynamicIcon.svgAsset(
    String assetName, {
    double size = SizesTokens.size24,
    Color? color,
    Color? backgroundColor,
  }) {
    return DSDynamicIcon._(
      type: DSIconType.svgAsset,
      assetOrUrl: assetName,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory for native IconData (Icons.home, etc)
  factory DSDynamicIcon.iconData(
    IconData iconData, {
    double size = SizesTokens.size24,
    Color? color,
    Color? backgroundColor,
  }) {
    return DSDynamicIcon._(
      type: DSIconType.iconData,
      iconData: iconData,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory for Network Images (URLs)
  factory DSDynamicIcon.network(
    String url, {
    double size = SizesTokens.size24,
    Color? color,
    Color? backgroundColor,
  }) {
    return DSDynamicIcon._(
      type: DSIconType.network,
      assetOrUrl: url,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildIcon(BuildContext context) {
    switch (type) {
      case DSIconType.svgAsset:
        return SvgPicture.asset(
          assetOrUrl!,
          width: size,
          height: size,
          fit: BoxFit.contain,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          // Usually we let DSIconAsset handle package prefix, but here we can support both
          // internal package absolute paths or generic ones.
        );
      case DSIconType.iconData:
        return Icon(iconData, size: size, color: color);
      case DSIconType.network:
        return CachedNetworkImage(
          imageUrl: assetOrUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: size,
            height: size,
            child: const Center(
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.error_outline,
            size: size,
            color: context.dsColors.error,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (backgroundColor == null) {
      return _buildIcon(context);
    }

    // Default container padding strategy logic
    double containerSize =
        size * 2.0; // By default container is double the icon size

    return DSRoundedContainer(
      width: containerSize,
      height: containerSize,
      borderRadius: RadiusTokens.fullRadius,
      backgroundColor: backgroundColor!,
      child: Center(child: _buildIcon(context)),
    );
  }
}

@Preview(
  name: 'DSDynamicIcon Preview - All types',
  brightness: Brightness.light,
)
Widget dsDynamicIconPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. IconData con fondo
          DSDynamicIcon.iconData(
            Icons.work_outline,
            backgroundColor: const Color(0xFFE5F1E5), // Verde clarito
            color: const Color(0xFF10B981), // Verde primario
          ),

          // 2. SVG Asset sin fondo
          DSDynamicIcon.svgAsset('assets/icons/apple.svg'),

          // 3. Network con fondo
          DSDynamicIcon.network(
            'https://cdn-icons-png.flaticon.com/128/0/747.png', // URL Publica
            backgroundColor: Colors.white,
          ),
        ],
      ),
    ],
  );
}
