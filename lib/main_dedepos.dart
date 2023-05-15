import 'package:dedepos/app/app.dart';
import 'package:dedepos/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/core.dart';
import 'flavors.dart';
import 'main_app.dart';

void main() async {
  F.appFlavor = Flavor.DEDEPOS;
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  await setUpServiceLocator();
  // await GetStorage.init('AppStorage');
  await initializeApp();
  //runApp(const App());
  runApp(App());
}
