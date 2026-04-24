import 'package:flutter/material.dart';

/// Typography tokens - Text styles and font definitions.
/// Defines all text styles used in the design system.
abstract class TypographyTokens {
  // ========== Font Families ==========
  /// Default font family for the application
  static const String fontFamilyDefault = 'Inter';

  // ========== Font Sizes (in logical pixels) ==========
  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize40 = 40.0;
  static const double fontSize48 = 48.0;

  // ========== Font Weights ==========
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ========== Line Heights (multiplier of font size) ==========
  static const double lineHeightCompact = 1.2;
  static const double lineHeightNormal = 1.0; // Default line height (1.0)
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightExtraRelaxed = 1.55;
  static const double lineHeightInput = 1.60;

  // ========== Letter Spacing ==========
  static const double letterSpacingTight = -0.2;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;

  // ========== Predefined Text Styles ==========

  /// Display Large (h1) - For main page titles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize48,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Display Medium (h2) - For section titles
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize40,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Display Small (h3)
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize32,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// headline Large (h4) - Card titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize24,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// headline Medium (h5)
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize20,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// headline Small (h6)
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize28,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Body Large - Body text, main content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize18,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Body Medium - Default body text
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize16,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Body Small - Secondary body text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize14,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingTight,
  );

  /// Body XSmall - Very small body text
  static const TextStyle bodyXSmall = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize12,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingTight,
  );

  /// Label Large - Buttons, labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize16,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );

  /// Label Medium - Default labels
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize14,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );

  /// Label Small - Small labels, tags
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize12,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Caption - Very small text, timestamps
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize12,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Caption Small
  static const TextStyle captionSmall = TextStyle(
    fontFamily: fontFamilyDefault,
    fontSize: fontSize10,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );
}
