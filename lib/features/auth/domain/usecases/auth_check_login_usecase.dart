import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/core/usecase/base_use_case.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthCheckLoginUseCase implements UseCaseNoParams<UserEntity?> {
  final AuthRepository repository;
  AuthCheckLoginUseCase(this.repository);
  @override
  DataState<UserEntity?> call() {
    return repository.currentUser();
  }
}
