import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_preferences_service.g.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  static const _hasCompletedOnboardingKey = 'hasCompletedOnboarding';

  bool get hasCompletedOnboarding =>
      _prefs.getBool(_hasCompletedOnboardingKey) ?? false;

  Future<void> setHasCompletedOnboarding() async {
    await _prefs.setBool(_hasCompletedOnboardingKey, true);
  }
}

@riverpod
SharedPreferencesService sharedPreferencesService(SharedPreferencesServiceRef ref) {
  throw UnimplementedError('sharedPreferencesService provider must be overridden in ProviderScope');
}
