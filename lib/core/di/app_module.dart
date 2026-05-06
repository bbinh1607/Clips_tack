import 'package:clips_tack/app/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @lazySingleton
  GoRouter get router => createAppRouter();
}
