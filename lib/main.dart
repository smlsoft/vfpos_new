import 'package:flutter/services.dart';
import 'package:localstore/localstore.dart';
import 'dart:io';
import 'package:dedepos/bloc/find_employee_by_name_bloc.dart';
import 'package:dedepos/bloc/find_member_by_tel_name_bloc.dart';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/bloc/product_category_bloc.dart';
import 'package:dedepos/dashboard_screen.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/loading.dart';
import 'package:dedepos/login.dart';
import 'package:dedepos/util/network.dart' as network;
import 'package:dedepos/welcome.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/api/rest_api.dart';
import 'package:dedepos/bloc/find_item_by_code_name_barcode_bloc.dart';
import 'package:dedepos/bloc/pos_process_bloc.dart';
import 'package:dedepos/bloc/server_bloc.dart';
import 'dart:developer' as dev;
import 'package:dedepos/api/network/server.dart' as server;
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await global.loading();
  network.connectivity();

  global.isServer = true;

  global.ipAddress = await network.ipAddress();

  // (await global.getDeviceId() == 'ABABA0AA-F156-4FF2-8AB0-DD25B7348819');
  dev.log(
      "***************** ${(global.isServer) ? "Server" : "Client"} *****************");
  if (global.isServer) {
    server.startServer();
  }
  runApp(
    MultiBlocProvider(
      providers: [
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
        BlocProvider(create: (context) => PosProcessBloc()),
        /*BlocProvider(create: (context) => OrderProcessBloc()),
        BlocProvider(create: (context) => TableBloc()),*/
        BlocProvider(create: (context) => PayScreenBloc()),
        BlocProvider(create: (context) => ServerBloc()),
        BlocProvider(
            create: (context) => ProductCategoryBloc(categoryGuid: '')),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Prompt',
        ),
        home: const Welcome(),
        routes: <String, WidgetBuilder>{
          '/menu': (BuildContext context) => const DashboardScreen(),
          '/loading': (BuildContext context) => const Loading(),
          '/login': (BuildContext context) => const Login(),
        },
      ),
    ),
  );
}
