import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final UserService _userService = UserService();

  static const _tokenKey = 'auth_token';

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        String? token = await user.getIdToken();
        if (token != null) {
          await _secureStorage.write(key: _tokenKey, value: token);
        }
      }

      return user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<User?> signUp(
    String email,
    String password, {
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        // Enviar email de verificación
        await user.sendEmailVerification();

        // Crear el usuario en nuestro servicio
        await _userService.createUser(
          user.uid,
          email,
          name: fullName,
          phoneNumber: phoneNumber,
        );

        // Guardar token
        String? token = await user.getIdToken();
        if (token != null) {
          await _secureStorage.write(key: _tokenKey, value: token);
        }
      }

      return user;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      // First, prevent any new token refreshes
      await _firebaseAuth.signOut();

      // Then clean up stored tokens
      await _secureStorage.delete(key: _tokenKey);

      // Give time for Firebase to clean up internal state
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Error al enviar correo de recuperación: $e');
      return false;
    }
  }

  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
}
