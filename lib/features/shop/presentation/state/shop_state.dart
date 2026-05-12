import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/product_entity.dart';
import '../../data/models/product_model.dart';

// Mock Products Provider
final productsProvider = Provider<List<ProductEntity>>((ref) {
  return [
    ProductModel(
      id: '1',
      name: 'Amazing T-Shirt',
      description: 'The perfect T-shirt for when you want to feel comfortable but still stylish. Amazing for all occasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look to the outfit. Perfect for the warmest days.',
      price: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&q=80&w=500',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['0xFF000000', '0xFF757575', '0xFFBDBDBD', '0xFFEEEEEE'],
    ),
    ProductModel(
      id: '2',
      name: 'Fabulous Pants',
      description: 'Elegant and comfortable pants for any occasion.',
      price: 15.00,
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&q=80&w=500',
      sizes: ['32', '34', '36', '38', '40', '42'],
      colors: ['0xFF000080', '0xFF000000', '0xFF8B4513'],
    ),
    ProductModel(
      id: '3',
      name: 'Spectacular Dress',
      description: 'A dress that will make you stand out.',
      price: 20.00,
      imageUrl: 'https://images.unsplash.com/photo-1539008835270-3832c3f87b8f?auto=format&fit=crop&q=80&w=500',
      sizes: ['S', 'M', 'L'],
      colors: ['0xFFFFD700', '0xFF000000'],
    ),
    ProductModel(
      id: '4',
      name: 'Stunning Jacket',
      description: 'Stay warm and stylish with this jacket.',
      price: 18.00,
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&q=80&w=500',
      sizes: ['M', 'L', 'XL'],
      colors: ['0xFF00008B', '0xFF000000'],
    ),
    ProductModel(
      id: '5',
      name: 'Wonderful Shoes',
      description: 'Comfortable and trendy shoes.',
      price: 83.00,
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&q=80&w=500',
      sizes: ['38', '39', '40', '41'],
      colors: ['0xFF008000', '0xFF000000'],
    ),
  ];
});

// Cart Notifier
class CartNotifier extends StateNotifier<List<CartItemEntity>> {
  CartNotifier() : super([]);

  void addToCart(ProductEntity product, String size, String color) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size && item.selectedColor == color,
    );

    if (existingIndex != -1) {
      final updatedCart = [...state];
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: updatedCart[existingIndex].quantity + 1,
      );
      state = updatedCart;
    } else {
      state = [
        ...state,
        CartItemEntity(
          product: product,
          quantity: 1,
          selectedSize: size,
          selectedColor: color,
        ),
      ];
    }
  }

  void incrementQuantity(int index) {
    final updatedCart = [...state];
    updatedCart[index] = updatedCart[index].copyWith(
      quantity: updatedCart[index].quantity + 1,
    );
    state = updatedCart;
  }

  void decrementQuantity(int index) {
    if (state[index].quantity > 1) {
      final updatedCart = [...state];
      updatedCart[index] = updatedCart[index].copyWith(
        quantity: updatedCart[index].quantity - 1,
      );
      state = updatedCart;
    } else {
      removeFromCart(index);
    }
  }

  void removeFromCart(int index) {
    state = [...state]..removeAt(index);
  }

  double get total => state.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemEntity>>((ref) {
  return CartNotifier();
});

// Selected Options for Detail Screen
final selectedSizeProvider = StateProvider.autoDispose<String>((ref) => '');
final selectedColorProvider = StateProvider.autoDispose<String>((ref) => '');
final currentProductImageIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
