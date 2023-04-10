import 'dart:io';

import 'package:dedepos/global_model.dart';
import 'package:dedepos/pos_screen/pos_secondary_screen.dart';
import 'package:dedepos/util/pos_client.dart';
import 'package:dedepos/util/select_mode_screen.dart';
import 'package:dedepos/bloc/find_employee_by_name_bloc.dart';
import 'package:dedepos/bloc/find_member_by_tel_name_bloc.dart';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/bloc/product_category_bloc.dart';
import 'package:dedepos/util/menu_screen.dart';
import 'package:dedepos/util/loading_screen.dart';
import 'package:dedepos/util/login.dart';
import 'package:dedepos/util/network.dart' as network;
import 'package:dedepos/util/welcome.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/api/rest_api.dart';
import 'package:dedepos/bloc/find_item_by_code_name_barcode_bloc.dart';
import 'package:dedepos/bloc/server_bloc.dart';
import 'package:dedepos/api/network/server.dart' as server;
import 'package:get_storage/get_storage.dart';
import 'package:presentation_displays/display.dart';
import 'package:presentation_displays/displays_manager.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const Welcome());
    case 'menu':
      return MaterialPageRoute(builder: (_) => const MenuScreen());
    case 'loading':
      return MaterialPageRoute(builder: (_) => const LoadingScreen());
    case 'login':
      return MaterialPageRoute(builder: (_) => const Login());
    case 'client':
      return MaterialPageRoute(builder: (_) => const PosClient());
    case 'select_mode':
      return MaterialPageRoute(builder: (_) => const SelectModeScreen());
    case 'presentation':
      return MaterialPageRoute(builder: (_) => const PosSecondaryScreen());
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sunmi จอแสดงผล
  List<Display>? displays = [];
  if (Platform.isAndroid) {
    displays = await global.displayManager.getDisplays();
    if (displays != null) {
      if (displays.length > 1) {
        global.isInternalCustomerDisplayConnected = true;
        global.internalCustomerDisplay = displays[1];
        print("internalCustomerDisplay");
      }
    }
  }

  if (Platform.isAndroid == false || displays!.isNotEmpty) {
    global.displayMachine = global.DisplayMachineEnum.posTerminal;
  } else {
    global.displayMachine = global.DisplayMachineEnum.customerDisplay;
  }

  if (global.displayMachine == global.DisplayMachineEnum.posTerminal) {
    await global.startLoading();
    // (await global.getDeviceId() == 'ABABA0AA-F156-4FF2-8AB0-DD25B7348819');
    server.startServer();
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
          /*BlocProvider(create: (context) => OrderProcessBloc()),
        BlocProvider(create: (context) => TableBloc()),*/
          BlocProvider(create: (context) => PayScreenBloc()),
          BlocProvider(create: (context) => ServerBloc()),
          BlocProvider(
              create: (context) => ProductCategoryBloc(categoryGuid: '')),
        ],
        child: MaterialApp(
          onGenerateRoute: generateRoute,
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Prompt',
          ),
        ),
      ),
    );
  } else {
    global.informationList.add(InformationModel(
      mode: 1,
      delaySecond: 60 * 5,
      sourceUrl: "http://techslides.com/demos/sample-videos/small.mp4",
    ));
    global.informationList.add(InformationModel(
      mode: 1,
      delaySecond: 60 * 5,
      sourceUrl:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    ));
    global.informationList.add(InformationModel(
      mode: 1,
      delaySecond: 60 * 5,
      sourceUrl:
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    ));
    global.informationList.add(InformationModel(
      mode: 1,
      delaySecond: 60 * 5,
      sourceUrl:
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    ));
    global.informationList.add(InformationModel(
      mode: 0,
      delaySecond: 10,
      sourceUrl:
          "https://i.pinimg.com/originals/3c/33/31/3c333137070fb1a0fa346b0eee0f3084.gif",
    ));
    global.informationList.add(InformationModel(
      mode: 0,
      delaySecond: 10,
      sourceUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/JPEG_compression_Example.jpg/800px-JPEG_compression_Example.jpg",
    ));
    global.informationList.add(InformationModel(
      mode: 0,
      delaySecond: 10,
      sourceUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B8%9E%E0%B8%A3%E0%B8%B0%E0%B8%A8%E0%B8%A3%E0%B8%B5%E0%B8%AA%E0%B8%A3%E0%B8%A3%E0%B9%80%E0%B8%9E%E0%B8%8A%E0%B8%8D%E0%B9%8C_0002.jpg/1280px-%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B8%9E%E0%B8%A3%E0%B8%B0%E0%B8%A8%E0%B8%A3%E0%B8%B5%E0%B8%AA%E0%B8%A3%E0%B8%A3%E0%B9%80%E0%B8%9E%E0%B8%8A%E0%B8%8D%E0%B9%8C_0002.jpg",
    ));

    if (Platform.isAndroid) {
      if (global.isInternalCustomerDisplayConnected) {
        global.displayManager
            .showSecondaryDisplay(displayId: 1, routerName: "presentation");
      }
    }
    runApp(const PosSecondaryScreen());
  }
}
