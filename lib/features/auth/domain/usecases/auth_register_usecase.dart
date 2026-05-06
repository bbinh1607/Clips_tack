import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/core/usecase/base_use_case.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRegisterUseCase implements UseCase<UserEntity, AuthRegisterParams> {
  final AuthRepository repository;
  AuthRegisterUseCase(this.repository);
  @override
  DataState<UserEntity> call(params) {
    return repository.register(params.email, params.password);
  }
}

class AuthRegisterParams {
  final String email;
  final String password;
  final String? name;
  final String? avatarUrl;
  final String? username;

  AuthRegisterParams({
    this.name,
    this.avatarUrl,
    this.username,
    required this.email,
    required this.password,
  });
}
