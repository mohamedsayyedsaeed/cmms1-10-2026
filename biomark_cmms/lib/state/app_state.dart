import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/i18n/translations.dart';

/// Replaces ThemeContext + LanguageContext from the prototype.
class AppState extends ChangeNotifier {
  AppState(this._prefs)
      : _themeMode =
            _prefs.getString(_kThemeKey) == 'dark' ? ThemeMode.dark : ThemeMode.light;

  static const String _kThemeKey = 'biomark-theme';

  final SharedPreferences _prefs;
  ThemeMode _themeMode;
  String _language = 'en';

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  String get language => _language;
  bool get isArabic => _language == 'ar';
  Locale get locale => Locale(_language);

  /// Translate a key; falls back to the key itself like the prototype's `t()`.
  String t(String key) => kTranslations[_language]?[key] ?? key;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setString(_kThemeKey, isDark ? 'dark' : 'light');
    notifyListeners();
  }

  void setLanguage(String language) {
    if (language == _language) return;
    _language = language;
    notifyListeners();
  }

  void toggleLanguage() => setLanguage(isArabic ? 'en' : 'ar');
}
