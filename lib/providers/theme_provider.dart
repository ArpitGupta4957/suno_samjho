import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';

/// Theme provider for managing app-wide theme state
class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.system;
  ThemeMode _resolvedThemeMode = ThemeMode.system;

  /// Get the current theme mode
  AppThemeMode get themeMode => _themeMode;

  /// Get the resolved theme mode (for MaterialApp)
  ThemeMode get resolvedThemeMode => _resolvedThemeMode;

  /// Check if dark mode is active
  bool get isDarkMode {
    if (_themeMode == AppThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == AppThemeMode.dark;
  }

  /// Initialize theme from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    
    if (savedMode != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => AppThemeMode.system,
      );
    }
    
    _updateResolvedThemeMode();
    notifyListeners();
  }

  /// Set the theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    _updateResolvedThemeMode();
    
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
    
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == AppThemeMode.system) {
      // If system, switch to opposite of current system brightness
      final systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      await setThemeMode(systemBrightness == Brightness.dark ? AppThemeMode.light : AppThemeMode.dark);
    } else if (_themeMode == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }

  /// Update the resolved theme mode based on current setting and system
  void _updateResolvedThemeMode() {
    switch (_themeMode) {
      case AppThemeMode.light:
        _resolvedThemeMode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        _resolvedThemeMode = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        _resolvedThemeMode = ThemeMode.system;
        break;
    }
  }

  /// Get the appropriate theme data for the current mode
  ThemeData getThemeData(BuildContext context) {
    final isDark = isDarkMode;
    return isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  /// Get a color based on the current theme
  Color getBackgroundColor(BuildContext context) {
    final isDark = isDarkMode;
    return isDark ? AppTheme.getDarkCardColor() : AppTheme.getLightCardColor();
  }

  /// Get text color based on the current theme
  Color getTextColor(BuildContext context, {bool isPrimary = true}) {
    final isDark = isDarkMode;
    if (isPrimary) {
      return isDark ? AppTheme.getDarkPrimaryText() : AppTheme.getLightPrimaryText();
    }
    return isDark ? AppTheme.getDarkSecondaryText() : AppTheme.getLightSecondaryText();
  }
}
