import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_interest.dart';
import '../../../../core/services/shared_preferences_service.dart';

part 'onboarding_provider.g.dart';

@riverpod
class SelectedInterests extends _$SelectedInterests {
  @override
  Set<UserInterest> build() {
    return {
      const UserInterest(id: '1', name: 'User Interface'),
      const UserInterest(id: '3', name: 'User Research'),
      const UserInterest(id: '7', name: 'Strategy'),
      const UserInterest(id: '8', name: 'Design Systems'),
    };
  }

  void toggle(UserInterest interest) {
    if (state.contains(interest)) {
      state = {
        for (final item in state)
          if (item != interest) item
      };
    } else {
      state = {...state, interest};
    }
  }
}

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesServiceProvider);
    await prefs.setHasCompletedOnboarding();
  }
}
