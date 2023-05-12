import 'package:dedepos/api/rest_api.dart';
import 'package:dedepos/bloc/bloc.dart';
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
        BlocProvider(
            create: (context) => FindItemByCodeNameBarcodeBloc(
                apiFindItemByCodeNameBarcode:
                    RestApiFindItemByCodeNameBarcode())),
        BlocProvider(
            create: (context) => FindMemberByTelNameBloc(
                apiFindMemberByTelName: RestApiFindMemberByTelName())),
        BlocProvider(
            create: (context) => FindEmployeeByNameBloc(
                apiFindEmployeeByName: RestApiFindEmployeeByWord())),
        BlocProvider(create: (context) => BillBloc()),
        BlocProvider(create: (context) => PayScreenBloc()),
        BlocProvider(create: (context) => ServerBloc()),
        BlocProvider(
            create: (context) => ProductCategoryBloc(categoryGuid: '')),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
