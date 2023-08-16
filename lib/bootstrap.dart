import 'package:dedepos/api/network/server.dart' as server;
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dedepos/app/http_verify.dart';
import 'package:dedepos/core/environment.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/objectbox.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/google_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedepos/global.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presentation_displays/display.dart';

void bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      runApp(await builder());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

Future<void> initializeApp() async {
  String jsonLanguageFileName = "assets/language.json";
  HttpOverrides.global = MyHttpOverrides();
  await setupDisplay();

  if (kDebugMode) {
    // Debug
    // สร้าง json จาก google sheet (จะไม่ทำงานทันที เพราะสร้าง source code ต้อง rerun ใหม่)
    await googleMultiLanguageSheetLoad().then((_) {
      String json = jsonEncode(global.languageSystemCode);
      File file = File(jsonLanguageFileName);
      file.writeAsString(json);
    });
  } else {
    // release
    // load ภาษาจาก assets (mode release)
    try {
      global.languageSystemCode = (json.decode(await rootBundle.loadString(jsonLanguageFileName)) as List).map((i) => LanguageSystemCodeModel.fromJson(i)).toList();
    } catch (_) {}
  }
  global.languageSelect(global.userScreenLanguage);
  //
  if (global.displayMachine == global.DisplayMachineEnum.posTerminal) {
    await setUpServiceLocator();
  } else if (global.displayMachine == global.DisplayMachineEnum.customerDisplay) {
    initCustomerDisplayBanner();
  }
}

Future<void> initializeEnvironmentConfig() async {
  // Storage
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  Environment().initConfig(environment);

  await GetStorage.init();
  global.appStorage = GetStorage();
  //
  try {
    global.userScreenLanguage = GetStorage().read("language");
  } catch (ex) {
    global.userScreenLanguage = "th";
  }
  global.applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  objectBoxInit();
  // Server
  await global.startLoading();
  server.startServer();
  // ตรวจสอบ Order จากระบบ Order OnLine
  Timer.periodic(const Duration(seconds: 1), (Timer t) async {
    if (global.loginSuccess) {
      if (global.shopId.isNotEmpty && global.checkOrderActive == false) {
        global.checkOrderOnline();
      }
    }
  });
}

Future<void> setupDisplay() async {
  // Sunmi จอแสดงผล
  List<Display>? displays = [];
  if (Platform.isAndroid) {
    displays = await global.displayManager.getDisplays();
    if (displays != null) {
      if (displays.length > 1) {
        global.isInternalCustomerDisplayConnected = true;
        global.internalCustomerDisplay = displays[1];
        //serviceLocator<Log>().debug("internalCustomerDisplay");
      }
    }
  }

  if (Platform.isAndroid == false || displays!.isNotEmpty) {
    global.displayMachine = global.DisplayMachineEnum.posTerminal;
  } else {
    global.displayMachine = global.DisplayMachineEnum.customerDisplay;
  }
}

bool isCustomerDisplayScreen() {
  return (global.displayMachine == global.DisplayMachineEnum.customerDisplay);
}

void initCustomerDisplayBanner() {
  global.informationList.add(InformationModel(
    mode: 1,
    delaySecond: 60 * 5,
    sourceUrl: "http://techslides.com/demos/sample-videos/small.mp4",
  ));
  global.informationList.add(InformationModel(
    mode: 1,
    delaySecond: 60 * 5,
    sourceUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
  ));
  global.informationList.add(InformationModel(
    mode: 1,
    delaySecond: 60 * 5,
    sourceUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  ));
  global.informationList.add(InformationModel(
    mode: 1,
    delaySecond: 60 * 5,
    sourceUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
  ));
  global.informationList.add(InformationModel(
    mode: 0,
    delaySecond: 10,
    sourceUrl: "https://i.pinimg.com/originals/3c/33/31/3c333137070fb1a0fa346b0eee0f3084.gif",
  ));
  global.informationList.add(InformationModel(
    mode: 0,
    delaySecond: 10,
    sourceUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/JPEG_compression_Example.jpg/800px-JPEG_compression_Example.jpg",
  ));
  global.informationList.add(InformationModel(
    mode: 0,
    delaySecond: 10,
    sourceUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B8%9E%E0%B8%A3%E0%B8%B0%E0%B8%A8%E0%B8%A3%E0%B8%B5%E0%B8%AA%E0%B8%A3%E0%B8%A3%E0%B9%80%E0%B8%9E%E0%B8%8A%E0%B8%8D%E0%B9%8C_0002.jpg/1280px-%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B8%9E%E0%B8%A3%E0%B8%B0%E0%B8%A8%E0%B8%A3%E0%B8%B5%E0%B8%AA%E0%B8%A3%E0%B8%A3%E0%B9%80%E0%B8%9E%E0%B8%8A%E0%B8%8D%E0%B9%8C_0002.jpg",
  ));
}
