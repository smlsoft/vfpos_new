import 'package:auto_route/auto_route.dart';
import 'package:dedepos/features/authentication/presentation/screens/authentication_screen.dart';

import '../features/splash/presentation/splash_screen.dart';
import 'package:dedepos/features/dashboard/presentation/dashboard_screen.dart';
import '../features/shop/shop.dart';
part 'app_routers.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get routerType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthenticationRoute.page),
        AutoRoute(page: SelectShopRoute.page),
        AutoRoute(page: DashboardRoute.page),

        /// routes go here
      ];
}
