// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_routers.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthenticationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthenticationPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardScreen(),
      );
    },
    InitPOSRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InitPOSScreen(),
      );
    },
    POSLoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const POSLoginScreen(),
      );
    },
    PosRoute.name: (routeData) {
      final args = routeData.argsAs<PosRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PosScreen(
          key: args.key,
          posScreenMode: args.posScreenMode,
        ),
      );
    },
    PosSecondaryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PosSecondaryScreen(),
      );
    },
    InitShopRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InitShopScreen(),
      );
    },
    SelectShopRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SelectShopScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    PrinterConfigRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PrinterConfigScreen(),
      );
    },
    LoginByEmployeeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginByEmployeePage(),
      );
    },
    MenuRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MenuScreen(),
      );
    },
    RegisterPosTerminalRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPosTerminalPage(),
      );
    },
  };
}

/// generated route for
/// [AuthenticationPage]
class AuthenticationRoute extends PageRouteInfo<void> {
  const AuthenticationRoute({List<PageRouteInfo>? children})
      : super(
          AuthenticationRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InitPOSScreen]
class InitPOSRoute extends PageRouteInfo<void> {
  const InitPOSRoute({List<PageRouteInfo>? children})
      : super(
          InitPOSRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitPOSRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [POSLoginScreen]
class POSLoginRoute extends PageRouteInfo<void> {
  const POSLoginRoute({List<PageRouteInfo>? children})
      : super(
          POSLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'POSLoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PosScreen]
class PosRoute extends PageRouteInfo<PosRouteArgs> {
  PosRoute({
    Key? key,
    required PosScreenModeEnum posScreenMode,
    List<PageRouteInfo>? children,
  }) : super(
          PosRoute.name,
          args: PosRouteArgs(
            key: key,
            posScreenMode: posScreenMode,
          ),
          initialChildren: children,
        );

  static const String name = 'PosRoute';

  static const PageInfo<PosRouteArgs> page = PageInfo<PosRouteArgs>(name);
}

class PosRouteArgs {
  const PosRouteArgs({
    this.key,
    required this.posScreenMode,
  });

  final Key? key;

  final PosScreenModeEnum posScreenMode;

  @override
  String toString() {
    return 'PosRouteArgs{key: $key, posScreenMode: $posScreenMode}';
  }
}

/// generated route for
/// [PosSecondaryScreen]
class PosSecondaryRoute extends PageRouteInfo<void> {
  const PosSecondaryRoute({List<PageRouteInfo>? children})
      : super(
          PosSecondaryRoute.name,
          initialChildren: children,
        );

  static const String name = 'PosSecondaryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InitShopScreen]
class InitShopRoute extends PageRouteInfo<void> {
  const InitShopRoute({List<PageRouteInfo>? children})
      : super(
          InitShopRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitShopRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SelectShopScreen]
class SelectShopRoute extends PageRouteInfo<void> {
  const SelectShopRoute({List<PageRouteInfo>? children})
      : super(
          SelectShopRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectShopRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PrinterConfigScreen]
class PrinterConfigRoute extends PageRouteInfo<void> {
  const PrinterConfigRoute({List<PageRouteInfo>? children})
      : super(
          PrinterConfigRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrinterConfigRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginByEmployeePage]
class LoginByEmployeeRoute extends PageRouteInfo<void> {
  const LoginByEmployeeRoute({List<PageRouteInfo>? children})
      : super(
          LoginByEmployeeRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginByEmployeeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MenuScreen]
class MenuRoute extends PageRouteInfo<void> {
  const MenuRoute({List<PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPosTerminalPage]
class RegisterPosTerminalRoute extends PageRouteInfo<void> {
  const RegisterPosTerminalRoute({List<PageRouteInfo>? children})
      : super(
          RegisterPosTerminalRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterPosTerminalRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
