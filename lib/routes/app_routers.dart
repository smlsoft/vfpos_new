import 'package:auto_route/auto_route.dart';
import 'package:dedepos/features/authentication/presentation/screens/authentication_screen.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_screen.dart';
import 'package:dedepos/features/pos/pos.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_secondary_screen.dart';
import 'package:dedepos/features/splash/presentation/splash_screen.dart';
import 'package:dedepos/features/dashboard/presentation/dashboard_screen.dart';
import 'package:dedepos/features/shop/shop.dart';
import 'package:dedepos/services/printer_config.dart';
import 'package:dedepos/util/menu_screen.dart';
import 'package:flutter/material.dart';

import '../global.dart';
part 'app_routers.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  RouteType get routerType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthenticationRoute.page),
        AutoRoute(page: SelectShopRoute.page),
        AutoRoute(page: DashboardRoute.page),
        AutoRoute(page: PosRoute.page),
        AutoRoute(page: POSLoginRoute.page),
        AutoRoute(page: InitPOSRoute.page),
        AutoRoute(page: InitShopRoute.page),
        AutoRoute(page: PosSecondaryRoute.page),
        AutoRoute(page: MenuRoute.page),
      ];
}
