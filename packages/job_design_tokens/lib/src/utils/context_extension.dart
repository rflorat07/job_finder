import 'package:flutter/material.dart';

/// BuildContext helpers safe to reuse across apps consuming the DS.
extension DSBuildContextExtension on BuildContext {
  /// Current theme.
  ThemeData get dsTheme => Theme.of(this);

  /// Theme text styles.
  TextTheme get dsTextTheme => dsTheme.textTheme;

  /// Theme color scheme.
  ColorScheme get dsColors => dsTheme.colorScheme;

  /// Active brightness.
  Brightness get dsBrightness => dsTheme.brightness;

  /// Whether the current theme is dark.
  bool get dsIsDarkMode => dsBrightness == Brightness.dark;

  /// Full viewport size for this context.
  Size get dsScreenSize => MediaQuery.sizeOf(this);

  /// Viewport width.
  double get dsWidth => dsScreenSize.width;

  /// Viewport height.
  double get dsHeight => dsScreenSize.height;

  /// Current safe area insets.
  EdgeInsets get dsSafeArea => MediaQuery.paddingOf(this);

  /// Whether software keyboard is visible.
  bool get dsIsKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// Unfocus current node and hide software keyboard.
  void dsHideKeyboard() => FocusScope.of(this).unfocus();

  /// Shows a generic snackbar and clears previous ones.
  void dsShowSnackBar(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message), action: action, duration: duration),
      );
  }

  /// Opens a modal bottom sheet using this context.
  Future<T?> dsShowBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
    );
  }

  /// Opens a dialog using this context.
  Future<T?> dsShowDialog<T>({required WidgetBuilder builder}) {
    return showDialog<T>(context: this, builder: builder);
  }
}
