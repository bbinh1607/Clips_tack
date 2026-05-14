import 'package:clips_tack/app/cubit/app_settings_cubit.dart';
import 'package:clips_tack/app/cubit/app_settings_state.dart';
import 'package:clips_tack/core/di/injection.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/theme/app_theme.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_check_login_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_google_login_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_login_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_logout_usecase.dart';
import 'package:clips_tack/features/auth/domain/usecases/auth_register_usecase.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/share/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipStackApp extends StatelessWidget {
  const ClipStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppSettingsCubit>()),
        BlocProvider(create: (_) => getIt<ClipboardBloc>()),
        BlocProvider(
          create: (_) => AuthBloc(
            getIt<AuthLoginUseCase>(),
            getIt<AuthRegisterUseCase>(),
            getIt<AuthLogoutUseCase>(),
            getIt<AuthCheckLoginUseCase>(),
            getIt<AuthGoogleLoginUseCase>(),
          )..add(const AuthEvent.checkLogin()),
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settingsState.themeMode,
            locale: settingsState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
