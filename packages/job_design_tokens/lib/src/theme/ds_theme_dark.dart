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
        secondaryContainer: Color(PrimitiveColors.greyscale900),
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
        titleTextStyle: TypographyTokens.headlineMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      // ========== Tab Bar Theme ==========
      tabBarTheme: TabBarThemeData(
        indicatorColor: SemanticColorsDark.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: SemanticColorsDark.primary,
        unselectedLabelColor: const Color(PrimitiveColors.greyscale500),
        labelStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.primary,
          height: TypographyTokens.lineHeightExtraRelaxed,
        ),
        unselectedLabelStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.textSecondary,
          height: TypographyTokens.lineHeightExtraRelaxed,
          fontWeight: TypographyTokens.fontWeightRegular,
        ),
        dividerColor: SemanticColorsDark.border,
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
        fillColor: SemanticColorsDark.buttonBackgroundColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.inputPaddingH,
          vertical: SpacingTokens.inputPaddingV,
        ),
        constraints: BoxConstraints(minHeight: SpacingTokens.inputHeight),

        border: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(
            color: SemanticColorsDark.buttonBackgroundColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(
            color: SemanticColorsDark.buttonBackgroundColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(
            color: SemanticColorsDark.buttonBackgroundColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsDark.error, width: 1),
        ),
        hintStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.textSecondary,
          fontWeight: FontWeight.w500,
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
        prefixIconConstraints: BoxConstraints(
          minWidth: SpacingTokens.spacing24,
          minHeight: SpacingTokens.spacing24,
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: SpacingTokens.spacing24,
          minHeight: SpacingTokens.spacing24,
        ),
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
        headlineLarge: TypographyTokens.headlineLarge.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        headlineMedium: TypographyTokens.headlineMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        headlineSmall: TypographyTokens.headlineSmall.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        bodyLarge: TypographyTokens.bodyLarge.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        bodyMedium: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsDark.textPrimary,
        ),
        bodySmall: TypographyTokens.bodySmall.copyWith(
          color: SemanticColorsDark.textPrimary,
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

      // ========== Linear Progress Indicator Theme =========
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: SemanticColorsDark.linearProgressIndicatorColor,
        linearTrackColor: SemanticColorsDark.linearProgressIndicatorTrackColor,
        linearMinHeight: SizesTokens.size5,
      ),
    );
  }
}
