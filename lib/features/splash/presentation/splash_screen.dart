import 'package:auto_route/auto_route.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/splash/domain/usecase/check_user_login_status.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() async {
    super.initState();

    Future.delayed(
      const Duration(seconds: 4),
      () {
        serviceLocator<CheckUserLoginStatus>()
            .checkIfUserLoggedIn()
            .then((isUserLoggedIn) {
          print(" after delay");
          context.router.pushAndPopUntil(
            isUserLoggedIn
                ? const DashboardRoute()
                : const AuthenticationRoute(),
            predicate: (_) => false,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/smlsoft-logo-512.png', // path to your image asset
            height: 900.0, width: 900.0,
          ),
        ),
      ),
    );
  }
}
