import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        String? token = await user.getIdToken();
        if (token != null) {
          await _secureStorage.write(key: _tokenKey, value: token);
        }
      }

      return user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
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
