// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clips_tack/app/cubit/app_settings_cubit.dart' as _i444;
import 'package:clips_tack/core/di/app_module.dart' as _i148;
import 'package:clips_tack/features/auth/data/datasources/auth_data_source.dart'
    as _i779;
import 'package:clips_tack/features/auth/data/datasources/user_data_source.dart'
    as _i424;
import 'package:clips_tack/features/auth/data/repositories/auth_repository_impl.dart'
    as _i429;
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart'
    as _i791;
import 'package:clips_tack/features/auth/domain/usecases/auth_check_login_usecase.dart'
    as _i814;
import 'package:clips_tack/features/auth/domain/usecases/auth_login_usecase.dart'
    as _i122;
import 'package:clips_tack/features/auth/domain/usecases/auth_logout_usecase.dart'
    as _i803;
import 'package:clips_tack/features/auth/domain/usecases/auth_register_usecase.dart'
    as _i425;
import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart'
    as _i647;
import 'package:clips_tack/features/clipboard/data/datasource/clipboard_local_data_source.dart'
    as _i789;
import 'package:clips_tack/features/clipboard/data/repository/clipboard_repository.dart'
    as _i31;
import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart'
    as _i279;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i444.AppSettingsCubit>(() => _i444.AppSettingsCubit());
    gh.lazySingleton<_i583.GoRouter>(() => appModule.router);
    gh.lazySingleton<_i789.ClipboardLocalDataSource>(
      () => _i789.ClipboardLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i779.AuthDataSource>(
      () => _i779.AuthDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i424.UserDataSource>(
      () => _i424.UserDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i31.ClipboardRepository>(
      () => _i31.ClipboardRepository(gh<_i789.ClipboardLocalDataSource>()),
    );
    gh.lazySingleton<_i279.ClipboardService>(
      () => _i279.SystemClipboardService(gh<_i31.ClipboardRepository>()),
    );
    gh.factory<_i647.ClipboardCubit>(
      () => _i647.ClipboardCubit.create(gh<_i279.ClipboardService>()),
    );
    gh.lazySingleton<_i791.AuthRepository>(
      () => _i429.AuthRepositoryImpl(
        gh<_i779.AuthDataSource>(),
        gh<_i424.UserDataSource>(),
      ),
    );
    gh.factory<_i814.AuthCheckLoginUseCase>(
      () => _i814.AuthCheckLoginUseCase(gh<_i791.AuthRepository>()),
    );
    gh.factory<_i803.AuthLogoutUseCase>(
      () => _i803.AuthLogoutUseCase(gh<_i791.AuthRepository>()),
    );
    gh.factory<_i425.AuthRegisterUseCase>(
      () => _i425.AuthRegisterUseCase(gh<_i791.AuthRepository>()),
    );
    gh.factory<_i122.AuthLoginUseCase>(
      () => _i122.AuthLoginUseCase(repository: gh<_i791.AuthRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i148.AppModule {}
