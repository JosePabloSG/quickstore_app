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
      await _firebaseAuth.signOut();
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
}
