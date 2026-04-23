import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders an SVG asset bundled in the Job Design System package.
class DSIconAsset extends StatelessWidget {
  const DSIconAsset({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.colorFilter,
    this.semanticLabel,
    this.fit = BoxFit.contain,
  });

  static const String packageName = 'job_design_system';

  /// Relative asset path inside the package, for example `assets/icons/google.svg`.
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      package: packageName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      semanticsLabel: semanticLabel,
    );
  }
}
