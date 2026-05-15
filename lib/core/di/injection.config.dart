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
import 'package:clips_tack/features/auth/domain/usecases/auth_google_login_usecase.dart'
    as _i985;
import 'package:clips_tack/features/auth/domain/usecases/auth_login_usecase.dart'
    as _i122;
import 'package:clips_tack/features/auth/domain/usecases/auth_logout_usecase.dart'
    as _i803;
import 'package:clips_tack/features/auth/domain/usecases/auth_register_usecase.dart'
    as _i425;
import 'package:clips_tack/features/clipboard/data/datasources/clipboard_local_data_source.dart'
    as _i789;
import 'package:clips_tack/features/clipboard/data/datasources/clipboard_system_data_source.dart'
    as _i280;
import 'package:clips_tack/features/clipboard/data/repositories/clipboard_repository_impl.dart'
    as _i31;
import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart'
    as _i279;
import 'package:clips_tack/features/clipboard/domain/usecases/add_clipboard_item.dart'
    as _i201;
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_usecases.dart'
    as _i210;
import 'package:clips_tack/features/clipboard/domain/usecases/delete_clipboard_item.dart'
    as _i202;
import 'package:clips_tack/features/clipboard/domain/usecases/load_clipboard_items.dart'
    as _i203;
import 'package:clips_tack/features/clipboard/domain/usecases/read_clipboard_text.dart'
    as _i204;
import 'package:clips_tack/features/clipboard/domain/usecases/save_clipboard_items.dart'
    as _i205;
import 'package:clips_tack/features/clipboard/domain/usecases/sort_clipboard_items.dart'
    as _i206;
import 'package:clips_tack/features/clipboard/domain/usecases/toggle_clipboard_pin.dart'
    as _i207;
import 'package:clips_tack/features/clipboard/domain/usecases/update_clipboard_item.dart'
    as _i208;
import 'package:clips_tack/features/clipboard/domain/usecases/write_clipboard_text.dart'
    as _i209;
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart'
    as _i647;
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
    gh.lazySingleton<_i280.ClipboardSystemDataSource>(
      () => _i280.ClipboardSystemDataSourceImpl(),
    );
    gh.lazySingleton<_i206.SortClipboardItems>(
      () => _i206.SortClipboardItems(),
    );
    gh.lazySingleton<_i424.UserDataSource>(
      () => _i424.UserDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i279.ClipboardRepository>(
      () => _i31.ClipboardRepositoryImpl(
        gh<_i789.ClipboardLocalDataSource>(),
        gh<_i280.ClipboardSystemDataSource>(),
      ),
    );
    gh.lazySingleton<_i779.AuthDataSource>(
      () => _i779.AuthDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i791.AuthRepository>(
      () => _i429.AuthRepositoryImpl(
        gh<_i779.AuthDataSource>(),
        gh<_i424.UserDataSource>(),
      ),
    );
    gh.factory<_i122.AuthLoginUseCase>(
      () => _i122.AuthLoginUseCase(repository: gh<_i791.AuthRepository>()),
    );
    gh.factory<_i814.AuthCheckLoginUseCase>(
      () => _i814.AuthCheckLoginUseCase(gh<_i791.AuthRepository>()),
    );
    gh.factory<_i985.AuthGoogleLoginUseCase>(
      () => _i985.AuthGoogleLoginUseCase(gh<_i791.AuthRepository>()),
    );
    gh.factory<_i803.AuthLogoutUseCase>(
      () => _i803.AuthLogoutUseCase(gh<_i791.AuthRepository>()),
    );
    gh.factory<_i425.AuthRegisterUseCase>(
      () => _i425.AuthRegisterUseCase(gh<_i791.AuthRepository>()),
    );
    gh.lazySingleton<_i203.LoadClipboardItems>(
      () => _i203.LoadClipboardItems(
        gh<_i279.ClipboardRepository>(),
        gh<_i206.SortClipboardItems>(),
      ),
    );
    gh.lazySingleton<_i205.SaveClipboardItems>(
      () => _i205.SaveClipboardItems(gh<_i279.ClipboardRepository>()),
    );
    gh.lazySingleton<_i204.ReadClipboardText>(
      () => _i204.ReadClipboardText(gh<_i279.ClipboardRepository>()),
    );
    gh.lazySingleton<_i209.WriteClipboardText>(
      () => _i209.WriteClipboardText(gh<_i279.ClipboardRepository>()),
    );
    gh.lazySingleton<_i201.AddClipboardItem>(
      () => _i201.AddClipboardItem(gh<_i206.SortClipboardItems>()),
    );
    gh.lazySingleton<_i208.UpdateClipboardItem>(
      () => _i208.UpdateClipboardItem(gh<_i206.SortClipboardItems>()),
    );
    gh.lazySingleton<_i207.ToggleClipboardPin>(
      () => _i207.ToggleClipboardPin(gh<_i206.SortClipboardItems>()),
    );
    gh.lazySingleton<_i202.DeleteClipboardItem>(
      () => _i202.DeleteClipboardItem(),
    );
    gh.lazySingleton<_i210.ClipboardUseCases>(
      () => _i210.ClipboardUseCases(
        gh<_i203.LoadClipboardItems>(),
        gh<_i205.SaveClipboardItems>(),
        gh<_i204.ReadClipboardText>(),
        gh<_i209.WriteClipboardText>(),
        gh<_i201.AddClipboardItem>(),
        gh<_i208.UpdateClipboardItem>(),
        gh<_i207.ToggleClipboardPin>(),
        gh<_i202.DeleteClipboardItem>(),
      ),
    );
    gh.factory<_i647.ClipboardBloc>(
      () => _i647.ClipboardBloc.create(gh<_i210.ClipboardUseCases>()),
    );
    return this;
  }
}

class _$AppModule extends _i148.AppModule {}
