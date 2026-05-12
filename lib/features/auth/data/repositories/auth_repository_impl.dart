import 'package:clips_tack/core/repositories/base_repository.dart';
import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/features/auth/data/datasources/auth_data_source.dart';
import 'package:clips_tack/features/auth/data/datasources/user_data_source.dart';
import 'package:clips_tack/features/auth/data/models/user_model.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl with BaseRepository implements AuthRepository {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;
  AuthRepositoryImpl(this._authDataSource, this._userDataSource);

  static const _syncUsersToFirestore = bool.fromEnvironment(
    'SYNC_AUTH_USERS_TO_FIRESTORE',
  );

  @override
  DataState<UserEntity> login(String email, String password) {
    return safeCall(
      call: () => _authDataSource.logIn(email, password),
      map: (model) => model.toEntity(),
    );
  }

  @override
  DataState<UserEntity> loginWithGoogle() {
    return safeCall(
      call: () async {
        final user = await _authDataSource.logInWithGoogle();
        return _syncUserToFirestoreIfEnabled(user);
      },
      map: (model) => model.toEntity(),
    );
  }

  @override
  DataState<UserEntity> register(
    String email,
    String password, {
    String? name,
    String? avatarUrl,
    String? username,
  }) {
    return safeCall(
      call: () async {
        final user = await _authDataSource.register(
          email,
          password,
          name: name,
          avatarUrl: avatarUrl,
          username: username,
        );
        return _syncUserToFirestoreIfEnabled(user);
      },
      map: (model) => model.toEntity(),
    );
  }

  @override
  DataState<void> logout() {
    return safeCall(call: () => _authDataSource.logOut(), map: (_) {});
  }

  @override
  DataState<bool> isLoggedIn() {
    return safeCall(
      call: () async => _authDataSource.isLoggedIn(),
      map: (isLoggedIn) => isLoggedIn,
    );
  }

  Future<UserModel> _syncUserToFirestoreIfEnabled(UserModel user) async {
    if (!_syncUsersToFirestore) {
      return user;
    }

    final userId = user.id;

    if (userId == null || userId.isEmpty) {
      return user;
    }

    try {
      final existingUser = await _userDataSource.getUser(userId);

      if (existingUser != null) {
        return existingUser;
      }

      return _userDataSource.createUser(user);
    } catch (_) {
      return user;
    }
  }
}
