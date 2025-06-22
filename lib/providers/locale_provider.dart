import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  static const String _localeKey = 'selected_locale';

  Future<void> loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      if (savedLocale != null) {
        state = Locale(savedLocale);
      }
    } catch (e) {
      // If loading fails, keep default locale
      debugPrint('Failed to load saved locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      state = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Failed to save locale: $e');
    }
  }

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ro'), // Romanian  
    Locale('fr'), // French
    Locale('de'), // German
    Locale('it'), // Italian
    Locale('es'), // Spanish
    Locale('nl'), // Dutch
  ];
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});