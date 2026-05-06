import 'package:clips_tack/app/cubit/app_settings_cubit.dart';
import 'package:clips_tack/app/cubit/app_settings_state.dart';
import 'package:clips_tack/core/di/injection.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/theme/app_theme.dart';
import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart';
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
        BlocProvider(create: (_) => getIt<ClipboardCubit>()),
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
