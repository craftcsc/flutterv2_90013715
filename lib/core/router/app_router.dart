import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/shared_preferences_service.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/ecommerce/presentation/screens/home_screen.dart';
import '../../features/ecommerce/presentation/screens/product_detail_screen.dart';
import '../../features/ecommerce/presentation/screens/cart_screen.dart';
import '../../features/ecommerce/presentation/screens/checkout_screen.dart';
import '../../features/transactions/presentation/screens/transactions_history_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final sharedPrefsService = ref.watch(sharedPreferencesServiceProvider);
  final hasCompletedOnboarding = sharedPrefsService.hasCompletedOnboarding;
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: hasCompletedOnboarding ? '/home' : '/onboarding',
    redirect: (BuildContext context, GoRouterState state) {
      final user = authState.asData?.value;
      final isLoggingInOrRegistering =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (isOnboarding) return null;

      // Si el usuario no está autenticado y quiere ingresar a checkout o historial de transacciones
      if (user == null && (state.matchedLocation == '/checkout' || state.matchedLocation == '/transactions')) {
        return '/login';
      }

      // Si el usuario ya inició sesión e intenta ir a login o registro, enviarlo a home
      if (user != null && isLoggingInOrRegistering) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
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
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsHistoryScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
}

