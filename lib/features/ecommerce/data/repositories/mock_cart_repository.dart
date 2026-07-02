import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

part 'mock_cart_repository.g.dart';

class MockCartRepository implements CartRepository {
  final List<CartItem> _items = [];

  @override
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_items);
  }

  @override
  Future<void> addToCart(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((i) => i.product.id == item.product.id && i.selectedSize == item.selectedSize && i.selectedColor == item.selectedColor);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + item.quantity);
    } else {
      _items.add(item);
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == itemId);
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _items.clear();
  }
}

@riverpod
CartRepository cartRepository(CartRepositoryRef ref) {
  return MockCartRepository();
}
