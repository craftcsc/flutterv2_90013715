import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'mock_product_repository.g.dart';

class MockProductRepository implements ProductRepository {
  final List<Product> _products = [
    const Product(
      id: '1',
      name: 'Amazing T-shirt',
      price: 12.00,
      imageUrl: 'https://via.placeholder.com/300x400/E9F2FF/007AFF?text=T-shirt',
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      availableColors: ['0xFF000000', '0xFF808080', '0xFFE0E0E0'],
    ),
    const Product(
      id: '2',
      name: 'Fabulous Pants',
      price: 15.00,
      imageUrl: 'https://via.placeholder.com/300x400/E9F2FF/007AFF?text=Pants',
      availableSizes: ['S', 'M', 'L'],
      availableColors: ['0xFF007AFF', '0xFF000000'],
    ),
    const Product(
      id: '3',
      name: 'Spectacular Dress',
      price: 20.00,
      imageUrl: 'https://via.placeholder.com/300x400/E9F2FF/007AFF?text=Dress',
      availableSizes: ['S', 'M', 'L'],
      availableColors: ['0xFFFFD700', '0xFFFF0000'],
    ),
    const Product(
      id: '4',
      name: 'Stunning Jacket',
      price: 18.00,
      imageUrl: 'https://via.placeholder.com/300x400/E9F2FF/007AFF?text=Jacket',
      availableSizes: ['M', 'L', 'XL'],
      availableColors: ['0xFF0000FF', '0xFF000000'],
    ),
  ];

  @override
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _products;
  }

  @override
  Future<Product> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _products;
  }
}

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return MockProductRepository();
}
