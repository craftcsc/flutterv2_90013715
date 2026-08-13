import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

/// Provider del estado de autenticación (Stream del usuario actual)
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provider controlador para operaciones de Auth (Login, Register, Logout)
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncData(null));

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e.toString(), stackTrace);
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e.toString(), stackTrace);
      return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _authRepository.signOut();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}
