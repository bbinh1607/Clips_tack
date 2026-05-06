part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login(String email, String password) = _Login;

  const factory AuthEvent.logout() = _Logout;

  const factory AuthEvent.checkLogin() = _CheckLogin;

  const factory AuthEvent.register(
    String email,
    String password,
    String? name,
    String? avatarUrl,
    String? username,
  ) = _Register;
}
