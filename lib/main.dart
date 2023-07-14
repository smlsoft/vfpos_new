import 'package:dedepos/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'app/app_view.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.DEDEPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  await initializeApp();
  runApp(App());
}
