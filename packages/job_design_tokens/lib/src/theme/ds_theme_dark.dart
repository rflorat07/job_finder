import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Dark theme data for the design system.
/// Constructs a complete ThemeData using semantic color tokens for dark mode.
class DSThemeDark {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ========== Color Scheme ==========
      colorScheme: ColorScheme.dark(
        primary: Color(PrimitiveColors.primary500),
        onPrimary: SemanticColorsDark.textPrimary,
        primaryContainer: Color(PrimitiveColors.primary800),
        onPrimaryContainer: SemanticColorsDark.textPrimary,

        secondary: Color(PrimitiveColors.greyscale400),
        onSecondary: SemanticColorsDark.textPrimary,
        secondaryContainer: Color(PrimitiveColors.greyscale300),
        onSecondaryContainer: SemanticColorsDark.textPrimary,

        tertiary: SemanticColorsDark.textDisabled,
        onTertiary: SemanticColorsDark.textPrimary,
        tertiaryContainer: Color(PrimitiveColors.primary800),
        onTertiaryContainer: SemanticColorsDark.textPrimary,

        error: SemanticColorsDark.error,
        onError: Color(PrimitiveColors.neutral100),
        errorContainer: SemanticColorsDark.errorBackground,
        onErrorContainer: SemanticColorsDark.error,

        surface: SemanticColorsDark.surface,
        onSurface: SemanticColorsDark.textPrimary,

        outline: SemanticColorsDark.border,
        outlineVariant: SemanticColorsDark.borderSubtle,

        scrim: SemanticColorsDark.overlay,
        shadow: SemanticColorsDark.shadow,
      ),

      // ========== Scaffold & Background ==========
      scaffoldBackgroundColor: SemanticColorsDark.background,
      canvasColor: SemanticColorsDark.surface,

      // ========== App Bar Theme ==========
      appBarTheme: AppBarTheme(
        backgroundColor: SemanticColorsDark.surface,
        foregroundColor: SemanticColorsDark.textPrimary,
        titleTextStyle: TypographyTokens.headingMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      // ========== Button Themes ==========
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SemanticColorsDark.primary,
          disabledBackgroundColor: SemanticColorsDark.primaryDisabled,
          foregroundColor: SemanticColorsDark.textOnInverse,
          disabledForegroundColor: SemanticColorsDark.textDisabled,
          textStyle: TypographyTokens.labelLarge,
          padding: EdgeInsets.symmetric(
            horizontal: SpacingTokens.buttonPaddingH,
            vertical: SpacingTokens.buttonPaddingV,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.buttonRadius,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          disabledBackgroundColor: SemanticColorsDark.primaryDisabled,
          foregroundColor: SemanticColorsDark.textSecondary,
          disabledForegroundColor: SemanticColorsDark.textDisabled,

          side: BorderSide(color: SemanticColorsDark.border),
          textStyle: TypographyTokens.labelMedium,
          padding: EdgeInsets.symmetric(
            horizontal: SpacingTokens.buttonPaddingH,
            vertical: SpacingTokens.buttonPaddingV,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.buttonRadius,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SemanticColorsDark.primary,
          textStyle: TypographyTokens.labelMedium,
          padding: EdgeInsets.symmetric(
            horizontal: SpacingTokens.buttonPaddingH,
            vertical: SpacingTokens.buttonPaddingV,
          ),
        ),
      ),

      // ========== Input Decoration Theme ==========
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: SemanticColorsDark.surfaceElevated,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.inputPaddingH,
          vertical: SpacingTokens.inputPaddingV,
        ),
        border: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.error, width: 2),
        ),
        hintStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.textTertiary,
        ),
        labelStyle: TypographyTokens.labelMedium.copyWith(
          color: SemanticColorsDark.textSecondary,
        ),
        floatingLabelStyle: TypographyTokens.labelMedium.copyWith(
          color: SemanticColorsDark.primary,
        ),
        helperStyle: TypographyTokens.captionSmall.copyWith(
          color: SemanticColorsDark.textTertiary,
        ),
        counterStyle: TypographyTokens.captionSmall.copyWith(
          color: SemanticColorsDark.textTertiary,
        ),
        errorStyle: TypographyTokens.captionSmall.copyWith(
          color: SemanticColorsDark.error,
        ),
        prefixIconColor: SemanticColorsDark.textSecondary,
        suffixIconColor: SemanticColorsDark.textSecondary,
      ),

      // ========== Card Theme ==========
      cardTheme: CardThemeData(
        color: SemanticColorsDark.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.cardRadius,
          side: BorderSide(color: SemanticColorsDark.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // ========== Dialog Theme ==========
      dialogTheme: DialogThemeData(
        backgroundColor: SemanticColorsDark.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.dialogRadius),
        alignment: Alignment.center,
      ),

      // ========== Text Themes ==========
      textTheme: TextTheme(
        displayLarge: TypographyTokens.displayLarge.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        displayMedium: TypographyTokens.displayMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        displaySmall: TypographyTokens.displaySmall.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        headlineLarge: TypographyTokens.headingLarge.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        headlineMedium: TypographyTokens.headingMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        headlineSmall: TypographyTokens.headingSmall.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        bodyLarge: TypographyTokens.bodyLarge.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        bodyMedium: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        bodySmall: TypographyTokens.bodySmall.copyWith(
          color: SemanticColorsDark.textSecondary,
        ),
        labelLarge: TypographyTokens.labelLarge.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        labelMedium: TypographyTokens.labelMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        labelSmall: TypographyTokens.labelSmall.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
      ),

      // ========== Other Themes ==========
      dividerTheme: DividerThemeData(
        color: SemanticColorsDark.divider,
        thickness: 1,
        space: SpacingTokens.spacing16,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: SemanticColorsDark.surfaceElevated,
        contentTextStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.mdRadius),
      ),
    );
  }
}
