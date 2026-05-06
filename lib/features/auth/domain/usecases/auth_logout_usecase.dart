import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/core/usecase/base_use_case.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthLogoutUseCase implements UseCaseNoParams<void> {
  final AuthRepository repository;
  AuthLogoutUseCase(this.repository);
  @override
  DataState<void> call() {
    return repository.logout();
  }
}
