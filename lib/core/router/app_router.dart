import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/shared_preferences_service.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/ecommerce/presentation/screens/home_screen.dart';
import '../../features/ecommerce/presentation/screens/product_detail_screen.dart';
import '../../features/ecommerce/presentation/screens/cart_screen.dart';
import '../../features/ecommerce/presentation/screens/checkout_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final sharedPrefsService = ref.watch(sharedPreferencesServiceProvider);
  final hasCompletedOnboarding = sharedPrefsService.hasCompletedOnboarding;

  return GoRouter(
    initialLocation: hasCompletedOnboarding ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
}
