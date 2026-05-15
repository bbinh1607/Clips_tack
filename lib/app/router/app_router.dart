import 'package:clips_tack/app/router/app_route_tree.dart';
import 'package:clips_tack/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';

export 'app_routes.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: buildAppRouteTree(),
  );
}
