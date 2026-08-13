import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  /// Stream para escuchar el estado de autenticación en tiempo real
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Usuario actual
  User? get currentUser => _firebaseAuth.currentUser;

  /// Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _parseAuthException(e);
    }
  }

  /// Registrar usuario con email y contraseña
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _parseAuthException(e);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _parseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe ningún usuario registrado con este correo.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Contraseña o credenciales incorrectas.';
      case 'email-already-in-use':
        return 'El correo electrónico ya se encuentra registrado.';
      case 'invalid-email':
        return 'El formato de correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'network-request-failed':
        return 'Error de conexión. Revisa tu acceso a internet.';
      default:
        return e.message ?? 'Ocurrió un error inesperado durante la autenticación.';
    }
  }
}
