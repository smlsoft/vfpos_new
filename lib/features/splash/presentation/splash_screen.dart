// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/core/environment.dart';
import 'package:dedepos/core/request.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/shop/presentation/bloc/select_shop_bloc.dart';
import 'package:dedepos/features/splash/domain/usecase/check_user_login_status.dart';
import 'package:dedepos/flavors.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/services/user_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      reload();
    });
    //reload();
  }

  void reload() {
    serviceLocator<CheckUserLoginStatus>().checkIfUserLoggedIn().then((isUserLoggedIn) async {
      if (isUserLoggedIn) {
        final user = await serviceLocator<UserCacheService>().getUser();

        if (F.appFlavor == Flavor.DEDEPOS) {
          if (user != null) {
            if (user.isDev == 1) {
              Environment().initConfig("DEV");
              serviceLocator<Request>().updateEndpoint();
            } else {
              Environment().initConfig("PROD");
              serviceLocator<Request>().updateEndpoint();
            }
          }
        }

        context.read<AuthenticationBloc>().add(AuthenticationEvent.authenticated(user: user!));

        await global.appStorage.write("token", user.token);
        global.apiConnected = true;
        global.loginSuccess = true;
        global.loginProcess = true;
        // global.apiConnected = true;

        serviceLocator<CheckUserLoginStatus>().checkIfUserSelectedShop().then((userSelectedShop) async {
          if (userSelectedShop != null) {
            global.apiShopID = userSelectedShop.guidfixed;
            context.read<SelectShopBloc>().add(SelectShopEvent.onSelectShopRefresh(shop: userSelectedShop));
            if (F.appFlavor == Flavor.DEDEPOS) {
              /*while (true) {
                try {
                  await global.getProfile();
                  context.router.pushAndPopUntil(const LoginByEmployeeRoute(),
                      predicate: (route) => false);
                  break;
                } catch (e) {
                  await Future.delayed(const Duration(seconds: 1));
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationEvent.authenticated(user: user));
                }
              }*/
              try {
                await global.getProfile();
              } catch (e) {}
              context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
              return;
            } else {
              context.router.pushAndPopUntil(const InitShopRoute(), predicate: (route) => false);
            }
          } else {
            context.router.pushAndPopUntil(const SelectShopRoute(), predicate: (route) => false);
          }
        });
      } else {
        // check flavor is dedepos
        if (F.appFlavor == Flavor.DEDEPOS) {
          context.router.pushAndPopUntil(const RegisterPosTerminalRoute(), predicate: (route) => false);
          return;
        } else {
          context.router.pushAndPopUntil(const AuthenticationRoute(), predicate: (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Center(
            child: Image.asset(
              'assets/smlsoft-logo-512.png', // path to your image asset
            ),
          ),
        ]),
      ),
    );
  }
}
