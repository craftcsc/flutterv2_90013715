import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/mock_product_repository.dart';
import '../providers/cart_provider.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

import '../../../../core/services/fcm_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final productsAsync = ref.watch(featuredProductsProvider);
    final cartItemsCount = ref.watch(cartControllerProvider).maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );
    final currentUser = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.appTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
            tooltip: 'Probar Notificación Push FCM',
            onPressed: () async {
              await FCMService().showTestNotification();
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.notifications_active, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '🔔 Notificación Push (Firebase FCM)\n¡Has recibido una notificación push de prueba!',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Color(0xFF007AFF),
                    duration: Duration(seconds: 4),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            tooltip: 'Historial de Transacciones',
            onPressed: () => context.push('/transactions'),
          ),
          const LanguageSelector(),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                onPressed: () => context.push('/cart'),
              ),
              if (cartItemsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AFF),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartItemsCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          if (currentUser != null) ...[
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              tooltip: 'Cerrar Sesión (${currentUser.email})',
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada correctamente.')),
                  );
                }
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.login, color: Color(0xFF007AFF)),
              tooltip: 'Iniciar Sesión',
              onPressed: () => context.push('/login'),
            ),
          ],
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F2FF),
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/800/600?random=2'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.perfectForYou, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.seeMore, style: const TextStyle(color: Color(0xFF007AFF))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => context.push('/product/${product.id}'),
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4F8),
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(product.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text('€ ${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => LoadingView(message: l10n.loading),
        error: (err, stack) => ErrorView(
          message: l10n.errorLoading,
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(featuredProductsProvider),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF007AFF),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.explore), label: l10n.explore),
          BottomNavigationBarItem(icon: const Icon(Icons.category_outlined), label: l10n.categories),
          BottomNavigationBarItem(icon: const Icon(Icons.storefront_outlined), label: l10n.stores),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: l10n.profile),
        ],
      ),
    );
  }
}

// Simple provider for fetching products
final featuredProductsProvider = FutureProvider((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getFeaturedProducts();
});
