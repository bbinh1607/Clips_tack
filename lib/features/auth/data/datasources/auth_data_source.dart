import 'package:clips_tack/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<UserModel> logIn(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logOut();
  bool isLoggedIn();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<UserModel> logIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return UserModel.fromFirebase(result.user!);
  }

  @override
  Future<void> logOut() {
    return _auth.signOut();
  }

  @override
  Future<UserModel> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return UserModel.fromFirebase(result.user!);
  }

  @override
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
