import 'package:dedepos/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'app.dart';
import 'core/core.dart';
import 'flavors.dart';
import 'main_app.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  await setUpServiceLocator();
  // await GetStorage.init('AppStorage');
  await initializeApp();

  F.appFlavor = Flavor.VFPOS;

  runApp(App());
}
