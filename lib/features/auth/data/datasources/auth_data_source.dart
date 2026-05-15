import 'package:clips_tack/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<UserModel> logIn(String email, String password);
  Future<UserModel> logInWithGoogle();
  Future<UserModel> register(
    String email,
    String password, {
    String? name,
    String? avatarUrl,
    String? username,
  });
  Future<void> logOut();
  bool isLoggedIn();
  UserModel? currentUser();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl(this._auth);

  static const _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
  static const _googleAuthScopes = <String>['email', 'profile'];

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInitialization;

  @override
  Future<UserModel> logIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return UserModel.fromFirebase(result.user!);
  }

  @override
  Future<UserModel> logInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.uiUnavailable,
        description: 'Google Sign-In is not supported on this platform.',
      );
    }

    final credential = await _createGoogleCredential();
    final result = await _auth.signInWithCredential(credential);

    return UserModel.fromFirebase(result.user!);
  }

  @override
  Future<void> logOut() async {
    final isGoogleUser =
        _auth.currentUser?.providerData.any(
          (provider) => provider.providerId == 'google.com',
        ) ??
        false;

    await _auth.signOut();

    if (!isGoogleUser) {
      return;
    }

    await _ensureGoogleSignInInitialized();
    try {
      await _googleSignIn.signOut();
    } on GoogleSignInException {
      // Firebase is already signed out; do not keep the app in a fake loading
      // or error state because the local Google credential cache failed.
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String password, {
    String? name,
    String? avatarUrl,
    String? username,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;
    final displayName = name?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      await user.updateDisplayName(displayName);
    }

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await user.updatePhotoURL(avatarUrl);
    }

    return UserModel(
      id: user.uid,
      email: user.email,
      name: displayName,
      avatarUrl: avatarUrl ?? user.photoURL,
      username: username ?? displayName,
    );
  }

  @override
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  @override
  UserModel? currentUser() {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return UserModel.fromFirebase(user);
  }

  Future<void> _ensureGoogleSignInInitialized() {
    final serverClientId = _googleServerClientId.trim();

    return _googleSignInInitialization ??= _googleSignIn.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
  }

  Future<OAuthCredential> _createGoogleCredential() async {
    final googleUser = await _googleSignIn.authenticate(
      scopeHint: _googleAuthScopes,
    );
    final idToken = googleUser.authentication.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.providerConfigurationError,
        description: 'Google did not return an ID token.',
      );
    }

    return GoogleAuthProvider.credential(idToken: idToken);
  }
}
