import 'package:bloc/bloc.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_check_login_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_google_login_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_login_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_logout_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_register_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLoginUseCase _loginUseCase;
  final AuthRegisterUseCase _registerUseCase;
  final AuthLogoutUseCase _logoutUseCase;
  final AuthCheckLoginUseCase _checkLoginUseCase;
  final AuthGoogleLoginUseCase _googleLoginUseCase;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._checkLoginUseCase,
    this._googleLoginUseCase,
  ) : super(const AuthState.initial()) {
    on<_Login>(_onLogin);
    on<_LoginWithGoogle>(_onLoginWithGoogle);
    on<_Register>(_onRegister);
    on<_Logout>(_onLogout);
    on<_CheckLogin>(_onCheckLogin);
  }

  Future<void> _onLogin(_Login event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _loginUseCase(
      AuthLoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onLoginWithGoogle(
    _LoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _googleLoginUseCase();

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onRegister(_Register event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _registerUseCase(
      AuthRegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
        avatarUrl: event.avatarUrl,
        username: event.username,
      ),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onLogout(_Logout event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onCheckLogin(_CheckLogin event, Emitter<AuthState> emit) async {
    final result = await _checkLoginUseCase();

    result.fold((_) => emit(const AuthState.unauthenticated()), (user) {
      if (user != null) {
        emit(AuthState.authenticated(user: user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }
}
