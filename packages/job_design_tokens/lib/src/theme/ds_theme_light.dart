import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Light theme data for the design system.
/// Constructs a complete ThemeData using semantic color tokens.
class DSThemeLight {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ========== Color Scheme ==========
      colorScheme: ColorScheme.light(
        primary: Color(PrimitiveColors.primary600),
        onPrimary: SemanticColorsLight.textOnInverse,
        primaryContainer: Color(PrimitiveColors.primary100),
        onPrimaryContainer: SemanticColorsLight.textPrimary,

        secondary: SemanticColorsLight.textSecondary,
        onSecondary: SemanticColorsLight.textOnInverse,
        secondaryContainer: Color(PrimitiveColors.greyscale0),
        onSecondaryContainer: SemanticColorsLight.textPrimary,

        tertiary: SemanticColorsLight.textDisabled,
        onTertiary: SemanticColorsLight.textPrimary,
        tertiaryContainer: Color(PrimitiveColors.primary800),
        onTertiaryContainer: SemanticColorsLight.textPrimary,

        error: SemanticColorsLight.error,
        onError: Colors.white,
        errorContainer: SemanticColorsLight.errorBackground,
        onErrorContainer: SemanticColorsLight.error,

        surface: SemanticColorsLight.surface,
        onSurface: SemanticColorsLight.textPrimary,

        outline: SemanticColorsLight.border,
        outlineVariant: SemanticColorsLight.borderSubtle,

        scrim: SemanticColorsLight.overlay,
        shadow: SemanticColorsLight.shadow,
      ),

      // ========== Scaffold & Background ==========
      scaffoldBackgroundColor: SemanticColorsLight.background,
      canvasColor: SemanticColorsLight.surface,

      // ========== App Bar Theme ==========
      appBarTheme: AppBarTheme(
        backgroundColor: SemanticColorsLight.surface,
        foregroundColor: SemanticColorsLight.textPrimary,
        titleTextStyle: TypographyTokens.headlineMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      // ========== Tab Bar Theme ==========
      tabBarTheme: TabBarThemeData(
        indicatorColor: SemanticColorsLight.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: SemanticColorsLight.primary,
        unselectedLabelColor: const Color(PrimitiveColors.greyscale500),
        labelStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsLight.primary,
          height: TypographyTokens.lineHeightExtraRelaxed,
        ),
        unselectedLabelStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsLight.textSecondary,
          fontWeight: TypographyTokens.fontWeightRegular,
          height: TypographyTokens.lineHeightExtraRelaxed,
        ),
        dividerColor: SemanticColorsLight.border,
      ),

      // ========== Button Themes ==========
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SemanticColorsLight.primary,
          disabledBackgroundColor: SemanticColorsLight.primaryDisabled,
          foregroundColor: SemanticColorsLight.textOnInverse,
          disabledForegroundColor: SemanticColorsLight.textDisabled,
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

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SemanticColorsLight.primary,
          disabledBackgroundColor: SemanticColorsLight.primaryDisabled,
          foregroundColor: SemanticColorsLight.textOnInverse,
          disabledForegroundColor: SemanticColorsLight.textDisabled,
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
          disabledBackgroundColor: SemanticColorsLight.primaryDisabled,
          foregroundColor: SemanticColorsLight.textSecondary,
          disabledForegroundColor: SemanticColorsLight.textDisabled,

          side: BorderSide(color: SemanticColorsLight.border),
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
          foregroundColor: SemanticColorsLight.primary,
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
        fillColor: SemanticColorsLight.buttonBackgroundColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.inputPaddingH,
          vertical: SpacingTokens.inputPaddingV,
        ),
        constraints: BoxConstraints(minHeight: SpacingTokens.inputHeight),

        border: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsLight.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsLight.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsLight.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsLight.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsLight.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.inputRadius,
          borderSide: BorderSide(color: SemanticColorsLight.error, width: 1),
        ),
        hintStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsLight.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: TypographyTokens.labelMedium.copyWith(
          color: SemanticColorsLight.textSecondary,
        ),
        floatingLabelStyle: TypographyTokens.labelMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        helperStyle: TypographyTokens.captionSmall.copyWith(
          color: SemanticColorsLight.textSecondary,
        ),
        counterStyle: TypographyTokens.captionSmall.copyWith(
          color: SemanticColorsLight.textSecondary,
        ),
        errorStyle: TypographyTokens.captionSmall.copyWith(
          color: SemanticColorsLight.error,
        ),
        prefixIconColor: SemanticColorsLight.textSecondary,
        suffixIconColor: SemanticColorsLight.textSecondary,
      ),

      // ========== Card Theme ==========
      cardTheme: CardThemeData(
        color: SemanticColorsLight.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.cardRadius,
          side: BorderSide(color: SemanticColorsLight.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // ========== Dialog Theme ==========
      dialogTheme: DialogThemeData(
        backgroundColor: SemanticColorsLight.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.dialogRadius),
        alignment: Alignment.center,
      ),

      // ========== Text Themes ==========
      textTheme: TextTheme(
        displayLarge: TypographyTokens.displayLarge.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        displayMedium: TypographyTokens.displayMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        displaySmall: TypographyTokens.displaySmall.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        headlineLarge: TypographyTokens.headlineLarge.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        headlineMedium: TypographyTokens.headlineMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        headlineSmall: TypographyTokens.headlineSmall.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        bodyLarge: TypographyTokens.bodyLarge.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        bodyMedium: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        bodySmall: TypographyTokens.bodySmall.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        labelLarge: TypographyTokens.labelLarge.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        labelMedium: TypographyTokens.labelMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        labelSmall: TypographyTokens.labelSmall.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
      ),

      // ========== Other Themes ==========
      dividerTheme: DividerThemeData(
        color: SemanticColorsLight.divider,
        thickness: 1,
        space: SpacingTokens.spacing16,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: SemanticColorsLight.surfaceElevated,
        contentTextStyle: TypographyTokens.bodyMedium.copyWith(
          color: SemanticColorsLight.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.mdRadius),
      ),

      // ========== Linear Progress Indicator Theme =========
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: SemanticColorsLight.primary,
        linearTrackColor: SemanticColorsLight.secondary,
        linearMinHeight: Sizes.size5,
      ),
    );
  }
}
