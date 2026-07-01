import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service that exposes and persists the current [ThemeMode].
///
/// Uses [ValueNotifier] so widgets can listen via [ValueListenableBuilder].
final ThemeService themeService = ThemeService._();

class ThemeService extends ValueNotifier<ThemeMode> {
  static const String _key = 'app_theme_mode';

  ThemeService._() : super(ThemeMode.system);

  /// Loads the persisted theme mode. Call once at app startup.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    value = _fromString(stored);
  }

  /// Updates and persists the selected theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _toString(mode));
  }

  static ThemeMode _fromString(String? raw) {
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String _toString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}
