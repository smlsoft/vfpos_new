import 'package:dedepos/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:dedepos/features/shop/presentation/bloc/select_shop_bloc.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()),
        BlocProvider(create: (_) => SelectShopBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
