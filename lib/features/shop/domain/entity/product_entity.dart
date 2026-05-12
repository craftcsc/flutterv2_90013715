class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> sizes;
  final List<String> colors;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sizes,
    required this.colors,
  });
}

class CartItemEntity {
  final ProductEntity product;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  CartItemEntity({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
  });

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
