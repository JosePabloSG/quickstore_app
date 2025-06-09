import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'users';

  Future<UserModel> createUser(
    String userId,
    String email, {
    String? name,
    String? phoneNumber,
  }) async {
    final user = UserModel(
      id: userId,
      name: name ?? email.split('@')[0], // Si no se proporciona nombre, usamos el email
      email: email,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
    );
    await _firestore.collection(collection).doc(userId).set(user.toJson());
    return user;
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection(collection).doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(collection).doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection(collection).doc(userId).delete();
  }
}
