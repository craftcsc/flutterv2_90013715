import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/cart_item.dart';
import '../../data/repositories/mock_cart_repository.dart';

part 'cart_provider.g.dart';

@riverpod
class CartController extends _$CartController {
  @override
  FutureOr<List<CartItem>> build() async {
    final repository = ref.watch(cartRepositoryProvider);
    return repository.getCartItems();
  }

  Future<void> addToCart(CartItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.addToCart(item);
      return repository.getCartItems();
    });
  }

  Future<void> removeFromCart(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.removeFromCart(itemId);
      return repository.getCartItems();
    });
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.updateQuantity(itemId, quantity);
      return repository.getCartItems();
    });
  }
}

@riverpod
double cartTotalAmount(CartTotalAmountRef ref) {
  final cartState = ref.watch(cartControllerProvider);
  return cartState.maybeWhen(
    data: (items) => items.fold(0, (total, item) => total + (item.product.price * item.quantity)),
    orElse: () => 0.0,
  );
}
