/// Spacing tokens - Consistent measurements for padding, margins, and gaps.
/// Uses an 8px base unit scaled into a comprehensive spacing scale.
abstract class SpacingTokens {
  /// 0 pixels (zero space)
  static const double zero = 0.0;

  /// 2 pixels (1/4 unit)
  static const double spacing2 = 2.0;

  /// 4 pixels (1/2 unit)
  static const double spacing4 = 4.0;

  /// 6 pixels (3/4 unit)
  static const double spacing6 = 6.0;

  /// 8 pixels (1 unit) - BASE UNIT
  static const double spacing8 = 8.0;

  /// 12 pixels (1.5 units)
  static const double spacing12 = 12.0;

  /// 14 pixels (1.75 units)
  static const double spacing14 = 14.0;

  /// 16 pixels (2 units)
  static const double spacing16 = 16.0;

  /// 20 pixels (2.5 units)
  static const double spacing20 = 20.0;

  /// 24 pixels (3 units)
  static const double spacing24 = 24.0;

  /// 28 pixels (3.5 units)
  static const double spacing28 = 28.0;

  /// 32 pixels (4 units)
  static const double spacing32 = 32.0;

  /// 40 pixels (5 units)
  static const double spacing40 = 40.0;

  /// 44 pixels (5.5 units)
  static const double spacing44 = 44.0;

  /// 48 pixels (6 units)
  static const double spacing48 = 48.0;

  /// 56 pixels (7 units)
  static const double spacing56 = 56.0;

  /// 64 pixels (8 units)
  static const double spacing64 = 64.0;

  /// 80 pixels (10 units)
  static const double spacing80 = 80.0;

  /// 96 pixels (12 units)
  static const double spacing96 = 96.0;

  // ========== Common Spacing Aliases ==========
  /// Extra small spacing (tightly packed)
  static const double xs = spacing4;

  /// Small spacing
  static const double sm = spacing8;

  /// Medium spacing (default)
  static const double md = spacing16;

  /// Large spacing
  static const double lg = spacing24;

  /// Extra large spacing
  static const double xl = spacing32;

  /// 2X large spacing
  static const double xl2 = spacing48;

  /// 3X large spacing
  static const double xl3 = spacing64;

  // ========== Component-Specific Spacing ==========
  /// Button padding (horizontal)
  static const double buttonPaddingH = spacing16;

  /// Button padding (vertical)
  static const double buttonPaddingV = spacing12;

  /// Button gap (between icon and text)
  static const double buttonGap = spacing8;

  /// Input padding (horizontal)
  static const double inputPaddingH = spacing12;

  /// Input padding (vertical)
  static const double inputPaddingV = spacing12;

  /// Input height
  static const double inputHeight = spacing48;

  /// Card padding
  static const double cardPadding = spacing24;

  /// Card gap
  static const double cardGap = spacing16;

  /// Dialog padding
  static const double dialogPadding = spacing24;

  /// Dialog content gap
  static const double dialogGap = spacing16;
}
