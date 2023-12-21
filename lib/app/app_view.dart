import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/bloc/bloc.dart';
import 'package:dedepos/bloc/posterminal_bloc.dart';
import 'package:dedepos/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:dedepos/features/shop/presentation/bloc/select_shop_bloc.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()),
        BlocProvider(create: (_) => SelectShopBloc()),
        BlocProvider(create: (context) => FindItemByCodeNameBarcodeBloc(apiFindItemByCodeNameBarcode: RestApiFindItemByCodeNameBarcode())),
        BlocProvider(create: (context) => FindMemberByTelNameBloc(apiFindMemberByTelName: ApiRepository())),
        BlocProvider(create: (context) => FindEmployeeByNameBloc(apiFindEmployeeByName: RestApiFindEmployeeByWord())),
        BlocProvider(create: (context) => BillBloc()),
        BlocProvider(create: (context) => PayScreenBloc()),
        BlocProvider(create: (context) => ServerBloc()),
        BlocProvider(create: (context) => ProductCategoryBloc(categoryGuid: '')),
        BlocProvider(create: (context) => PosTerminalBloc(posterminalRepository: ApiRepository())),
      ],
      child: MaterialApp.router(
        title: 'Village Fund POS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          // English
          Locale('en', 'US'),
          // Thai
          Locale('th', 'TH'),
          // Lao
          Locale('lo', 'LA'),
          // Vietnam
          Locale('vi', 'VN'),
          // Myanmar
          Locale('my', 'MM'),
          // Cambodia
          Locale('km', 'KH'),
          // Japan
          Locale('ja', 'JP'),
          // China
          Locale('zh', 'CN'),
          // Korea
          Locale('ko', 'KR'),
          // Malaysia
          Locale('ms', 'MY'),
          // Indonesia
          Locale('id', 'ID'),
          // Singapore
          Locale('en', 'SG'),
          // Philippines
          Locale('en', 'PH'),
          // India
          Locale('en', 'IN'),
          // Hong Kong
          Locale('zh', 'HK'),
          // Taiwan
          Locale('zh', 'TW'),
        ],
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
