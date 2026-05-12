import 'package:flutter/material.dart';

import 'primitive_colors.dart';

/// Semantic color tokens for Light theme.
/// Maps primitive colors to meaningful UI roles.
class SemanticColorsLight {
  // ========== Surface & Background ==========
  /// Primary application background
  static const Color background = Color(PrimitiveColors.primary500);

  /// Surface for cards, containers, elevated elements
  static const Color surface = Color(PrimitiveColors.greyscale0);

  /// Elevated surface for modals, popovers
  static const Color surfaceElevated = Color(PrimitiveColors.greyscale0);

  /// Inverse surface for emphasis
  static const Color surfaceInverse = Color(PrimitiveColors.neutral100);

  // ========== Text & Foreground ==========
  /// Primary text color - highest contrast
  static const Color textPrimary = Color(PrimitiveColors.greyscale900);

  /// Secondary text color
  static const Color textSecondary = Color(PrimitiveColors.greyscale400);

  /// Tertiary text color
  static const Color textTertiary = Color(PrimitiveColors.primary500);

  /// Text on inverse surfaces
  static const Color textOnInverse = Color(PrimitiveColors.greyscale0);

  /// Disabled text
  static const Color textDisabled = Color(PrimitiveColors.greyscale0);

  /// Disabled secondary text
  static const Color textSecondaryDisabled = Color(
    PrimitiveColors.greyscale200,
  );

  // ========== Brand & Actions ==========
  /// Primary brand color
  static const Color primary = Color(PrimitiveColors.primary500);

  /// Primary hover state
  static const Color primaryHover = Color(PrimitiveColors.primary500);

  /// Primary pressed state
  static const Color primaryPressed = Color(PrimitiveColors.primary800);

  /// Primary disabled state
  static const Color primaryDisabled = Color(PrimitiveColors.greyscale100);

  /// Secondary accent
  static const Color secondary = Color(PrimitiveColors.greyscale100);

  /// Secondary hover
  static const Color secondaryHover = Color(PrimitiveColors.greyscale25);

  // ========== Semantic States ==========
  /// Success/positive feedback
  static const Color success = Color(PrimitiveColors.success50);

  /// Success hover
  static const Color successHover = Color(PrimitiveColors.primary500);

  /// Error/negative feedback
  static const Color error = Color(PrimitiveColors.error100);

  /// Error hover
  static const Color errorHover = Color(PrimitiveColors.error100);

  /// Warning/caution
  static const Color warning = Color(PrimitiveColors.warning50);

  /// Warning hover
  static const Color warningHover = Color(PrimitiveColors.warning100);

  /// Info/informational
  static const Color info = Color(PrimitiveColors.warning100);

  /// Info hover
  static const Color infoHover = Color(PrimitiveColors.warning200);

  // ========== Borders & Dividers ==========
  /// Primary border color
  static const Color border = Color(PrimitiveColors.greyscale100);

  /// Subtle border (lower contrast)
  static const Color borderSubtle = Color(PrimitiveColors.neutral30);

  /// Strong border (high contrast)
  static const Color borderStrong = Color(PrimitiveColors.neutral70);

  /// Divider line
  static const Color divider = Color(PrimitiveColors.neutral30);

  // ========== Backgrounds for States ==========
  /// Success background (light)
  static const Color successBackground = Color(PrimitiveColors.success25);

  /// Error background (light)
  static const Color errorBackground = Color(PrimitiveColors.error25);

  /// Warning background (light)
  static const Color warningBackground = Color(PrimitiveColors.warning25);

  /// Info background (light)
  static const Color infoBackground = Color(PrimitiveColors.warning25);

  /// Primary background (light)
  static const Color primaryBackground = Color(PrimitiveColors.primary100);

  // ========== Overlays & Shadows ==========
  /// Overlay for modals (with opacity applied elsewhere)
  static const Color overlay = Color(PrimitiveColors.neutral100);

  /// Shadow color base
  static const Color shadow = Color(PrimitiveColors.neutral100);

  // ========== Button & Background ==========
  /// Primary button background (light)
  static const Color buttonBackgroundColor = Color(PrimitiveColors.greyscale0);

  /// Primary button foreground (light)
  static const Color buttonForegroundColor = Color(
    PrimitiveColors.greyscale900,
  );

  /// Back button background (light)
  static const Color backButtonBackgroundColor = Color(
    PrimitiveColors.primary400,
  );

  // ========== Linear Progress Indicator Theme ==========
  /// Primary color for linear progress indicators (light)
  static const Color linearProgressIndicatorColor = Color(
    PrimitiveColors.primary500,
  );

  /// Track color for linear progress indicators (light)
  static const Color linearProgressIndicatorTrackColor = Color(
    PrimitiveColors.greyscale100,
  );
}
