import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getFeaturedProducts();
  Future<List<Product>> getProductsByCategory(String category);
  Future<Product> getProductById(String id);
}
