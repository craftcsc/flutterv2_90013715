import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_localizations.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cartState = ref.watch(cartControllerProvider);
    final totalAmount = ref.watch(cartTotalAmountProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.yourBag, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.yourBag));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.image_outlined, color: Color(0xFFB0CFFF)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${l10n.color}: ${item.selectedColor} / ${l10n.size}: ${item.selectedSize}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _QuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      ref.read(cartControllerProvider.notifier).updateQuantity(item.id, item.quantity - 1);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  _QuantityButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      ref.read(cartControllerProvider.notifier).updateQuantity(item.id, item.quantity + 1);
                                    },
                                    isAdd: true,
                                  ),
                                  const Spacer(),
                                  Text('€ ${(item.product.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.total, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                        Text('€ ${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        child: Text(l10n.checkout, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => LoadingView(message: l10n.loading),
        error: (err, stack) => ErrorView(
          message: l10n.errorLoading,
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(cartControllerProvider),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isAdd;

  const _QuantityButton({required this.icon, required this.onPressed, this.isAdd = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isAdd ? const Color(0xFFE9F2FF) : const Color(0xFFF0F4F8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: isAdd ? const Color(0xFF007AFF) : Colors.black54),
      ),
    );
  }
}
