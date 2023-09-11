import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_secondary_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'app/app_view.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.DEDEPOS;
  await initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  global.applicationName = "DeDe Pos";
  await initializeApp();
  runApp((isCustomerDisplayScreen()) ? const PosSecondaryScreen() : App());
}
