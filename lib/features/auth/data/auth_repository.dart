import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/fcm_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

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
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _syncUserProfile(credential.user!);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _parseAuthException(e);
    }
  }

  /// Registrar usuario con email y contraseña y guardar perfil con rol en Firestore
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String role = 'client',
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final assignedRole = (email.toLowerCase().contains('admin') || role == 'admin')
            ? 'admin'
            : 'client';

        await _firestore.collection('users').doc(credential.user!.uid).set({
          'email': email,
          'role': assignedRole,
          'fcmToken': FCMService().fcmToken,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _parseAuthException(e);
    }
  }

  /// Sincronizar token FCM y asegurar perfil en Firestore al iniciar sesión
  Future<void> _syncUserProfile(User user) async {
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final defaultRole = (user.email?.toLowerCase().contains('admin') ?? false)
          ? 'admin'
          : 'client';

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'role': defaultRole,
          'fcmToken': FCMService().fcmToken,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.collection('users').doc(user.uid).update({
          if (FCMService().fcmToken != null) 'fcmToken': FCMService().fcmToken,
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  /// Stream para escuchar el rol del usuario en tiempo real desde Firestore
  Stream<String> watchUserRole(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return doc.data()!['role'] as String? ?? 'client';
      }
      return 'client';
    });
  }

  /// Modificar o asignar rol de usuario en Firestore
  Future<void> setUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).set({'role': role}, SetOptions(merge: true));
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
