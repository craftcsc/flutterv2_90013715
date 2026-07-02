// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentRepositoryHash() => r'00c825f4a3af9c788bde7893c4c9054144bfad6a';

/// See also [paymentRepository].
@ProviderFor(paymentRepository)
final paymentRepositoryProvider =
    AutoDisposeProvider<PaymentRepository>.internal(
      paymentRepository,
      name: r'paymentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentRepositoryRef = AutoDisposeProviderRef<PaymentRepository>;
String _$testCardsHash() => r'102d812c5851b419ef82e57bd81d41fbc6de7e72';

/// See also [testCards].
@ProviderFor(testCards)
final testCardsProvider = AutoDisposeFutureProvider<List<TestCard>>.internal(
  testCards,
  name: r'testCardsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$testCardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TestCardsRef = AutoDisposeFutureProviderRef<List<TestCard>>;
String _$paymentProcessHash() => r'cd89e681bb99cca582ace9c9b3c0def5a2a6213c';

/// See also [PaymentProcess].
@ProviderFor(PaymentProcess)
final paymentProcessProvider =
    AutoDisposeNotifierProvider<
      PaymentProcess,
      AsyncValue<PaymentResponse?>
    >.internal(
      PaymentProcess.new,
      name: r'paymentProcessProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentProcessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaymentProcess = AutoDisposeNotifier<AsyncValue<PaymentResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
