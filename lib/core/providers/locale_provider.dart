import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shared_preferences_service.dart';

/// Provider that holds the currently selected [Locale].
/// Persists the selection via [SharedPreferencesService].
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferencesService _prefs;

  LocaleNotifier(this._prefs)
      : super(Locale(_prefs.selectedLocale));

  void setLocale(Locale locale) {
    state = locale;
    _prefs.setSelectedLocale(locale.languageCode);
  }
}
