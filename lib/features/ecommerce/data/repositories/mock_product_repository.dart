import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../core/services/shared_preferences_service.dart';

part 'mock_product_repository.g.dart';

/// Raw mock product data (source-of-truth when cache is empty).
const _mockProductsJson = '''[
  {"id":"1","name":"Amazing T-shirt","price":12.0,"imageUrl":"https://picsum.photos/300/400?random=21","availableSizes":["XS","S","M","L","XL"],"availableColors":["0xFF000000","0xFF808080","0xFFE0E0E0"]},
  {"id":"2","name":"Fabulous Pants","price":15.0,"imageUrl":"https://picsum.photos/300/400?random=22","availableSizes":["S","M","L"],"availableColors":["0xFF007AFF","0xFF000000"]},
  {"id":"3","name":"Spectacular Dress","price":20.0,"imageUrl":"https://picsum.photos/300/400?random=23","availableSizes":["S","M","L"],"availableColors":["0xFFFFD700","0xFFFF0000"]},
  {"id":"4","name":"Stunning Jacket","price":18.0,"imageUrl":"https://picsum.photos/300/400?random=24","availableSizes":["M","L","XL"],"availableColors":["0xFF0000FF","0xFF000000"]}
]''';

List<Product> _decodeProducts(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
}

/// A mock implementation of [ProductRepository] with cache-first strategy.
///
/// On first load the repository:
///  1. Checks [SharedPreferencesService] for a previously cached JSON string.
///  2. If found, returns the cached list immediately (no delay).
///  3. If not found, simulates a network delay, then persists and returns the
///     hardcoded mock data.
class MockProductRepository implements ProductRepository {
  final SharedPreferencesService _prefs;

  MockProductRepository(this._prefs);

  @override
  Future<List<Product>> getFeaturedProducts() async {
    // ── Cache read ────────────────────────────────────────────────────────────
    final cached = _prefs.cachedProductsJson;
    if (cached != null) {
      return _decodeProducts(cached);
    }

    // ── Simulate network ──────────────────────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 800));
    final products = _decodeProducts(_mockProductsJson);

    // ── Cache write ───────────────────────────────────────────────────────────
    await _prefs.setCachedProductsJson(_mockProductsJson);

    return products;
  }

  @override
  Future<Product> getProductById(String id) async {
    final products = await getFeaturedProducts();
    return products.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return getFeaturedProducts();
  }
}

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return MockProductRepository(prefs);
}

