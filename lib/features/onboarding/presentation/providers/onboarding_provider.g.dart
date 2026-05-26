// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedInterestsHash() => r'dac4b157963c13cb1a91aa69061a5d6c59c2dbad';

/// See also [SelectedInterests].
@ProviderFor(SelectedInterests)
final selectedInterestsProvider =
    AutoDisposeNotifierProvider<SelectedInterests, Set<UserInterest>>.internal(
      SelectedInterests.new,
      name: r'selectedInterestsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedInterestsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedInterests = AutoDisposeNotifier<Set<UserInterest>>;
String _$onboardingControllerHash() =>
    r'd433531d3b63b6ad3f3d84288e57c18a4060f3bb';

/// See also [OnboardingController].
@ProviderFor(OnboardingController)
final onboardingControllerProvider =
    AutoDisposeAsyncNotifierProvider<OnboardingController, void>.internal(
      OnboardingController.new,
      name: r'onboardingControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
