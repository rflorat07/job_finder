import 'package:flutter/material.dart';

/// Border radius tokens - Consistent corner rounding.
/// Creates a hierarchy from sharp to very rounded styles.
abstract class RadiusTokens {
  /// No rounding (sharp corners)
  static const double none = 0.0;

  /// 4 pixels - Subtle rounding
  static const double xs = 4.0;

  /// 8 pixels - Small rounding
  static const double sm = 8.0;

  /// 10 pixels - xSmall rounding
  static const double xsm = 10.0;

  /// 12 pixels - Medium rounding
  static const double md = 12.0;

  /// 16 pixels - Large rounding
  static const double lg = 16.0;

  /// 20 pixels - Extra large rounding
  static const double xl = 20.0;

  /// 24 pixels - 2X large rounding
  static const double xl2 = 24.0;

  /// 32 pixels - 3X large rounding
  static const double xl3 = 32.0;

  /// 9999 pixels - Fully rounded (pill/capsule shape)
  static const double full = 9999.0;

  // ========== BorderRadius presets ==========

  /// No rounding BorderRadius
  static const BorderRadius noneRadius = BorderRadius.zero;

  /// Extra small BorderRadius
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));

  /// Small BorderRadius
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));

  /// Extra small BorderRadius
  static const BorderRadius xsmRadius = BorderRadius.all(Radius.circular(xsm));

  /// Medium BorderRadius
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));

  /// Large BorderRadius
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));

  /// Extra large BorderRadius
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));

  /// 2X large BorderRadius
  static const BorderRadius xl2Radius = BorderRadius.all(Radius.circular(xl2));

  /// 3X large BorderRadius
  static const BorderRadius xl3Radius = BorderRadius.all(Radius.circular(xl3));

  /// Fully rounded BorderRadius (pill shape)
  static const BorderRadius fullRadius = BorderRadius.all(
    Radius.circular(full),
  );

  // ========== Component-Specific Radius ==========

  /// Button border radius
  static const BorderRadius buttonRadius = mdRadius;

  /// Input field border radius
  static const BorderRadius inputRadius = xsmRadius;

  /// Card border radius
  static const BorderRadius cardRadius = lgRadius;

  /// Dialog border radius
  static const BorderRadius dialogRadius = lgRadius;

  /// Tooltip border radius
  static const BorderRadius tooltipRadius = smRadius;

  /// Chip border radius
  static const BorderRadius chipRadius = fullRadius;
}
