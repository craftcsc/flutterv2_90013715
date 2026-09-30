import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class FirestoreProductRepository implements ProductRepository {
  final FirebaseFirestore _firestore;

  FirestoreProductRepository([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  static final List<Product> _initialSeedProducts = [
    const Product(
      id: 'prod_1',
      name: 'Camiseta Casual Urbana',
      price: 19.99,
      imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500',
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      availableColors: ['0xFF000000', '0xFF808080', '0xFF007AFF'],
    ),
    const Product(
      id: 'prod_2',
      name: 'Pantalón Chino Moderno',
      price: 34.50,
      imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500',
      availableSizes: ['S', 'M', 'L'],
      availableColors: ['0xFF1B365D', '0xFF8B5A2B', '0xFF000000'],
    ),
    const Product(
      id: 'prod_3',
      name: 'Vestido Estival Elegante',
      price: 49.00,
      imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=500',
      availableSizes: ['S', 'M', 'L'],
      availableColors: ['0xFFFF3B30', '0xFFFFD700', '0xFF000000'],
    ),
    const Product(
      id: 'prod_4',
      name: 'Chaqueta Bomber Premium',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
      availableSizes: ['M', 'L', 'XL'],
      availableColors: ['0xFF2E3D48', '0xFF000000', '0xFF4A5568'],
    ),
  ];

  /// Escucha en tiempo real los cambios en la colección de productos.
  /// Emite productos semilla inmediatamente y captura cualquier error de Firestore/permisos
  /// para evitar que la interfaz quede bloqueada con 'Error al cargar'.
  @override
  Stream<List<Product>> watchProducts() async* {
    yield _initialSeedProducts;

    yield* _productsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        _seedInitialProducts();
        return _initialSeedProducts;
      }
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        return Product(
          id: doc.id,
          name: data['name'] as String? ?? 'Producto',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          imageUrl: data['imageUrl'] as String? ??
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          availableSizes: (data['availableSizes'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['M'],
          availableColors: (data['availableColors'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['0xFF007AFF'],
        );
      }).toList();
    }).handleError((_) => _initialSeedProducts);
  }

  /// Si la colección está vacía en Firestore, se puebla con productos de demostración
  Future<void> _seedInitialProducts() async {
    try {
      final snapshot = await _productsCollection.limit(1).get();
      if (snapshot.docs.isEmpty) {
        for (final p in _initialSeedProducts) {
          final json = p.toJson();
          json.remove('id');
          await _productsCollection.doc(p.id).set(json);
        }
      }
    } catch (e) {
      // Ignorar si hay restricciones de permisos offline
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final snapshot = await _productsCollection.get();
      if (snapshot.docs.isEmpty) {
        await _seedInitialProducts();
        return _initialSeedProducts;
      }
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        return Product(
          id: doc.id,
          name: data['name'] as String? ?? 'Producto',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          imageUrl: data['imageUrl'] as String? ??
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          availableSizes: (data['availableSizes'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['M'],
          availableColors: (data['availableColors'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['0xFF007AFF'],
        );
      }).toList();
    } catch (_) {
      return _initialSeedProducts;
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final doc = await _productsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        return Product(
          id: doc.id,
          name: data['name'] as String? ?? 'Producto',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          imageUrl: data['imageUrl'] as String? ??
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          availableSizes: (data['availableSizes'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['M'],
          availableColors: (data['availableColors'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['0xFF007AFF'],
        );
      }
    } catch (_) {}
    return _initialSeedProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => _initialSeedProducts.first,
    );
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return getFeaturedProducts();
  }

  /// Crear un nuevo producto en Firestore (Admin)
  @override
  Future<void> createProduct(Product product) async {
    final json = product.toJson();
    json.remove('id');
    json['createdAt'] = FieldValue.serverTimestamp();
    await _productsCollection.add(json);
  }

  /// Editar un producto existente en Firestore (Admin)
  @override
  Future<void> updateProduct(Product product) async {
    final json = product.toJson();
    json.remove('id');
    json['updatedAt'] = FieldValue.serverTimestamp();
    await _productsCollection.doc(product.id).update(json);
  }

  /// Eliminar un producto de Firestore (Admin)
  @override
  Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }
}
