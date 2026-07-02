import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/payment_repository.dart';
import '../../domain/entities/payment_models.dart';

part 'payment_provider.g.dart';

@riverpod
PaymentRepository paymentRepository(PaymentRepositoryRef ref) {
  return PaymentRepository();
}

@riverpod
Future<List<TestCard>> testCards(TestCardsRef ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getTestCards();
}

@riverpod
class PaymentProcess extends _$PaymentProcess {
  @override
  AsyncValue<PaymentResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> processPayment(double amount, String cardNumber) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(paymentRepositoryProvider);
      final request = PaymentRequest(amount: amount, cardNumber: cardNumber);
      final response = await repository.processPayment(request);
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
