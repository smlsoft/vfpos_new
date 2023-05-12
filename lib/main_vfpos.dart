import 'package:dedepos/app/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
// import 'app.dart';
import 'core/core.dart';
import 'flavors.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/bootstrap.dart';

void main() async {
  Logger.level = Level.info;
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  await setUpServiceLocator();
  // await GetStorage.init('AppStorage');
  await initializeApp();

  F.appFlavor = Flavor.VFPOS;

  runApp(App());
}
