import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'users';

  Future<UserModel> createUser(String userId, String email) async {
    final user = UserModel(id: userId, email: email, createdAt: DateTime.now());

    await _firestore.collection(collection).doc(userId).set(user.toMap());
    return user;
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection(collection).doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(collection).doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection(collection).doc(userId).delete();
  }
}
