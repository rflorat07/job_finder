import 'package:flutter/material.dart';

import 'primitive_colors.dart';

/// Semantic color tokens for Dark theme.
/// Maps primitive colors to meaningful UI roles optimized for dark mode.
class SemanticColorsDark {
  // ========== Surface & Background ==========
  /// Primary application background (dark)
  static const Color background = Color(PrimitiveColors.greyscale900);

  /// Surface for cards, containers, elevated elements
  static const Color primaryContainer = Color(PrimitiveColors.greyscale900);

  /// Surface for cards, containers, elevated elements
  static const Color secondaryContainer = Color(PrimitiveColors.greyscale800);

  /// Surface for cards, containers, elevated elements
  static const Color tertiaryContainer = Color(PrimitiveColors.greyscale900);

  /// Surface for cards, containers, elevated elements (dark)
  static const Color surface = Color(PrimitiveColors.neutral90);

  /// Elevated surface for modals, popovers (dark)
  static const Color surfaceElevated = Color(PrimitiveColors.neutral80);

  /// Inverse surface for emphasis (light mode appearance)
  static const Color surfaceInverse = Color(PrimitiveColors.neutral0);

  // ========== Text & Foreground ==========
  /// Primary text color - highest contrast (light on dark)
  static const Color textPrimary = Color(PrimitiveColors.neutral0);

  /// Secondary text color - medium contrast (70% opacity light)
  static const Color textSecondary = Color(PrimitiveColors.greyscale400);

  /// Tertiary text color - lowest contrast (50% opacity light)
  static const Color textTertiary = Color(PrimitiveColors.greyscale300);

  /// Text on inverse surfaces (dark)
  static const Color textOnInverse = Color(PrimitiveColors.neutral100);

  /// Disabled text
  static const Color textDisabled = Color(PrimitiveColors.greyscale0);

  /// Disabled secondary text (dark)
  static const Color textSecondaryDisabled = Color(
    PrimitiveColors.greyscale500,
  );

  // ========== Brand & Actions ==========
  /// Primary brand color (adjusted for dark theme)
  static const Color primary = Color(PrimitiveColors.primary500);

  /// Primary hover state
  static const Color primaryHover = Color(PrimitiveColors.primary400);

  /// Primary pressed state
  static const Color primaryPressed = Color(PrimitiveColors.primary500);

  /// Primary disabled state
  static const Color primaryDisabled = Color(PrimitiveColors.greyscale100);

  /// Secondary accent (adjusted for dark theme)
  static const Color secondary = Color(PrimitiveColors.greyscale0);

  /// Secondary hover
  static const Color secondaryHover = Color(PrimitiveColors.greyscale300);

  // ========== Semantic States ==========
  /// Success/positive feedback
  static const Color success = Color(PrimitiveColors.success200);

  /// Success hover
  static const Color successHover = Color(PrimitiveColors.success300);

  /// Error/negative feedback
  static const Color error = Color(PrimitiveColors.error100);

  /// Error hover
  static const Color errorHover = Color(PrimitiveColors.error300);

  /// Error disabled
  static const Color errorDisabled = Color(PrimitiveColors.error25);

  /// Warning/caution
  static const Color warning = Color(PrimitiveColors.warning200);

  /// Warning hover
  static const Color warningHover = Color(PrimitiveColors.warning300);

  /// Info/informational
  static const Color info = Color(PrimitiveColors.warning200);

  /// Info hover
  static const Color infoHover = Color(PrimitiveColors.warning200);

  // ========== Borders & Dividers ==========
  /// Primary border color
  static const Color border = Color(PrimitiveColors.greyscale100);

  /// Subtle border (lower contrast)
  static const Color borderSubtle = Color(PrimitiveColors.neutral80);

  /// Strong border (high contrast)
  static const Color borderStrong = Color(PrimitiveColors.neutral50);

  /// Divider line
  static const Color divider = Color(PrimitiveColors.neutral80);

  // ========== Backgrounds for States ==========
  /// Success background (dark)
  static const Color successBackground = Color(PrimitiveColors.success100);

  /// Error background (dark)
  static const Color errorBackground = Color(PrimitiveColors.error100);

  /// Warning background (dark)
  static const Color warningBackground = Color(PrimitiveColors.warning100);

  /// Info background (dark)
  static const Color infoBackground = Color(PrimitiveColors.warning100);

  /// Primary background (dark)
  static const Color primaryBackground = Color(PrimitiveColors.primary50);

  /// Primary disabled background (dark)
  static const Color primaryDisabledBackground = Color(
    PrimitiveColors.greyscale800,
  );

  /// Secondary disabled background (dark)
  static const Color secondaryDisabledBackground = Color(
    PrimitiveColors.greyscale0,
  );

  // ========== Overlays & Shadows ==========
  /// Overlay for modals (with opacity applied elsewhere)
  static const Color overlay = Color(PrimitiveColors.neutral0);

  /// Shadow color base
  static const Color shadow = Color(PrimitiveColors.neutral0);

  // ========== Button & Background ==========
  /// Primary button background (dark)
  static const Color buttonBackgroundColor = Color(
    PrimitiveColors.greyscale800,
  );

  /// Primary button foreground (dark)
  static const Color buttonForegroundColor = Color(PrimitiveColors.greyscale0);

  /// Back button background (dark)
  static const Color backButtonBackgroundColor = Color(
    PrimitiveColors.primary400,
  );

  /// Default button background (dark)
  static const Color defaultButtonBackgroundColor = Color(
    PrimitiveColors.primary900,
  );

  /// Icon background (dark)
  static const Color iconBackgroundColor = Color(PrimitiveColors.greyscale700);

  // ========== Linear Progress Indicator Theme ==========
  /// Primary color for linear progress indicators (dark)
  static const Color linearProgressIndicatorColor = Color(
    PrimitiveColors.primary500,
  );

  /// Track color for linear progress indicators (dark)
  static const Color linearProgressIndicatorTrackColor = Color(
    PrimitiveColors.greyscale700,
  );

  // ========== Filter Chip Theme ==========
  /// Selected color for filter chips (dark)
  static const Color filterChipSelectedColor = Color(
    PrimitiveColors.greyscale800,
  );

  // ========== Company Theme ==========
  /// Background color for company names (dark)
  static const Color companyBackgroundColor = Color(
    PrimitiveColors.greyscale700,
  );

  // ========== Input Fields ==========
  /// Background color for input fields (dark)
  static const Color inputBackgroundColor = Color(PrimitiveColors.greyscale800);
}
