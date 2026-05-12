import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  DataState<UserEntity> login(String email, String password);
  DataState<UserEntity> loginWithGoogle();
  DataState<UserEntity> register(
    String email,
    String password, {
    String? name,
    String? avatarUrl,
    String? username,
  });
  DataState<void> logout();
  DataState<bool> isLoggedIn();
}
