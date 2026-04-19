import 'package:flutter/material.dart';

import 'primitive_colors.dart';

/// Semantic color tokens for Dark theme.
/// Maps primitive colors to meaningful UI roles optimized for dark mode.
class SemanticColorsDark {
  // ========== Surface & Background ==========
  /// Primary application background (dark)
  static const Color background = Color(PrimitiveColors.neutral100);

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
  static const Color textSecondary = Color(PrimitiveColors.neutral20);

  /// Tertiary text color - lowest contrast (50% opacity light)
  static const Color textTertiary = Color(PrimitiveColors.neutral40);

  /// Text on inverse surfaces (dark)
  static const Color textOnInverse = Color(PrimitiveColors.neutral100);

  /// Disabled text
  static const Color textDisabled = Color(PrimitiveColors.greyscale500);

  // ========== Brand & Actions ==========
  /// Primary brand color (adjusted for dark theme)
  static const Color primary = Color(PrimitiveColors.primary500);

  /// Primary hover state
  static const Color primaryHover = Color(PrimitiveColors.primary500);

  /// Primary pressed state
  static const Color primaryPressed = Color(PrimitiveColors.primary500);

  /// Primary disabled state
  static const Color primaryDisabled = Color(PrimitiveColors.greyscale100);

  /// Secondary accent (adjusted for dark theme)
  static const Color secondary = Color(PrimitiveColors.secondary40);

  /// Secondary hover
  static const Color secondaryHover = Color(PrimitiveColors.secondary30);

  // ========== Semantic States ==========
  /// Success/positive feedback
  static const Color success = Color(PrimitiveColors.success40);

  /// Success hover
  static const Color successHover = Color(PrimitiveColors.success30);

  /// Error/negative feedback
  static const Color error = Color(PrimitiveColors.error40);

  /// Error hover
  static const Color errorHover = Color(PrimitiveColors.error30);

  /// Warning/caution
  static const Color warning = Color(PrimitiveColors.warning40);

  /// Warning hover
  static const Color warningHover = Color(PrimitiveColors.warning30);

  /// Info/informational
  static const Color info = Color(PrimitiveColors.info40);

  /// Info hover
  static const Color infoHover = Color(PrimitiveColors.info30);

  // ========== Borders & Dividers ==========
  /// Primary border color
  static const Color border = Color(PrimitiveColors.neutral70);

  /// Subtle border (lower contrast)
  static const Color borderSubtle = Color(PrimitiveColors.neutral80);

  /// Strong border (high contrast)
  static const Color borderStrong = Color(PrimitiveColors.neutral50);

  /// Divider line
  static const Color divider = Color(PrimitiveColors.neutral80);

  // ========== Backgrounds for States ==========
  /// Success background (dark)
  static const Color successBackground = Color(PrimitiveColors.success80);

  /// Error background (dark)
  static const Color errorBackground = Color(PrimitiveColors.error80);

  /// Warning background (dark)
  static const Color warningBackground = Color(PrimitiveColors.warning80);

  /// Info background (dark)
  static const Color infoBackground = Color(PrimitiveColors.info80);

  /// Primary background (dark)
  static const Color primaryBackground = Color(PrimitiveColors.primary50);

  // ========== Overlays & Shadows ==========
  /// Overlay for modals (with opacity applied elsewhere)
  static const Color overlay = Color(PrimitiveColors.neutral0);

  /// Shadow color base
  static const Color shadow = Color(PrimitiveColors.neutral0);
}
