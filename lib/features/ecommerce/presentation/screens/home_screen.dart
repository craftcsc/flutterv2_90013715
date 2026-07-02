import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/mock_product_repository.dart';
import '../providers/cart_provider.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/shared_preferences_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // This could also be managed by a separate FutureProvider, but using the repository directly
    // in a FutureBuilder is fine for simple fetching if not sharing state.
    // However, Riverpod is requested, so let's make a quick provider for it.
    final productsAsync = ref.watch(featuredProductsProvider);
    final cartItemsCount = ref.watch(cartControllerProvider).maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.appTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.black),
            tooltip: 'Reset Onboarding',
            onPressed: () async {
              await ref.read(sharedPreferencesServiceProvider).resetOnboarding();
              if (context.mounted) context.go('/onboarding');
            },
          ),
          const LanguageSelector(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
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
