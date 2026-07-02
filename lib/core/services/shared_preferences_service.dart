import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_preferences_service.g.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // ── Onboarding ──────────────────────────────────────────────────────────────
  static const _hasCompletedOnboardingKey = 'hasCompletedOnboarding';

  bool get hasCompletedOnboarding =>
      _prefs.getBool(_hasCompletedOnboardingKey) ?? false;

  Future<void> setHasCompletedOnboarding() async {
    await _prefs.setBool(_hasCompletedOnboardingKey, true);
  }

  Future<void> resetOnboarding() async {
    await _prefs.setBool(_hasCompletedOnboardingKey, false);
  }

  // ── Product cache ────────────────────────────────────────────────────────────
  /// Key used to store the JSON-encoded list of products.
  static const _cachedProductsKey = 'cachedProducts';

  /// Returns the raw JSON string of cached products, or null if not cached.
  String? get cachedProductsJson => _prefs.getString(_cachedProductsKey);

  /// Persists [json] (a JSON-encoded list of products) to local storage.
  Future<void> setCachedProductsJson(String json) async {
    await _prefs.setString(_cachedProductsKey, json);
  }

  /// Clears the product cache.
  Future<void> clearProductCache() async {
    await _prefs.remove(_cachedProductsKey);
  }

  // ── Locale / Language ────────────────────────────────────────────────────────
  static const _localeKey = 'selectedLocale';

  /// Returns the persisted language code, defaulting to Spanish ('es').
  String get selectedLocale => _prefs.getString(_localeKey) ?? 'es';

  /// Persists [languageCode] (e.g. 'es', 'en') for the next app launch.
  Future<void> setSelectedLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
  }
}

@riverpod
SharedPreferencesService sharedPreferencesService(SharedPreferencesServiceRef ref) {
  throw UnimplementedError('sharedPreferencesService provider must be overridden in ProviderScope');
}

