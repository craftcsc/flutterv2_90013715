import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/cart_item.dart';
import '../../data/repositories/mock_product_repository.dart';
import '../providers/cart_provider.dart';

final productDetailProvider = FutureProvider.family((ref, String id) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductById(id);
});

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: productAsync.when(
        data: (product) {
          // Initialize defaults if not set
          _selectedSize ??= product.availableSizes.first;
          _selectedColor ??= product.availableColors.first;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: const Color(0xFFE9F2FF),
                        child: const Center(child: Icon(Icons.image_outlined, size: 100, color: Color(0xFFB0CFFF))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.favorite_border),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '€ ${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, color: Colors.black87),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'The perfect product for when you want to feel comfortable but still stylish. Amazing for all occasions.',
                              style: TextStyle(color: Colors.black54, height: 1.5),
                            ),
                            const SizedBox(height: 24),
                            const Text('Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            Row(
                              children: product.availableSizes.map((size) {
                                final isSelected = size == _selectedSize;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedSize = size),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFF0F4F8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            const Text('Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            Row(
                              children: product.availableColors.map((colorHex) {
                                final isSelected = colorHex == _selectedColor;
                                final color = Color(int.parse(colorHex));
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedColor = colorHex),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: color,
                                      radius: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final item = CartItem(
                        id: const Uuid().v4(),
                        product: product,
                        quantity: 1,
                        selectedSize: _selectedSize!,
                        selectedColor: _selectedColor!,
                      );
                      ref.read(cartControllerProvider.notifier).addToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} added to bag!')),
                      );
                    },
                    child: const Text('+ Add to bag', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
