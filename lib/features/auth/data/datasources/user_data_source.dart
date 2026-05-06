import 'package:clips_tack/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class UserDataSource {
  Future<UserModel> createUser(UserModel user);
  Future<UserModel?> getUser(String id);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

@LazySingleton(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<UserModel> createUser(UserModel user) async {
    await _users.doc(user.id).set({
      ...user.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return user;
  }

  @override
  Future<UserModel?> getUser(String id) async {
    final doc = await _users.doc(id).get();

    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.id).update(user.toJson());
  }

  @override
  Future<void> deleteUser(String id) async {
    await _users.doc(id).delete();
  }
}
