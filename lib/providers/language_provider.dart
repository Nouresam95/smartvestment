import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // ✅ الإنجليزية هي اللغة الافتراضية

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code');

    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    } else {
      _locale = const Locale('en'); // ✅ التأكد أن الافتراضي هو الإنجليزية
    }

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }
}
