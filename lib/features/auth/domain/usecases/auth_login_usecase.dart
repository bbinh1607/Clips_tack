import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/core/usecase/base_use_case.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthLoginUseCase implements UseCase<UserEntity, AuthLoginParams> {
  final AuthRepository repository;
  AuthLoginUseCase({required this.repository});

  @override
  DataState<UserEntity> call(AuthLoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class AuthLoginParams {
  final String email;
  final String password;

  AuthLoginParams({required this.email, required this.password});
}
