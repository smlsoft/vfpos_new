import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_secondary_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app/app_view.dart';
import 'flavors.dart';
import 'package:dedepos/global.dart' as global;

void main() async {
  F.appFlavor = Flavor.VFPOS;
  WidgetsFlutterBinding.ensureInitialized();
  initializeEnvironmentConfig();
  Intl.defaultLocale = "th";
  global.applicationName = "Village Fund POS";
  await initializeApp();
  Future.delayed(Duration(seconds: 2), () {
    runApp((isCustomerDisplayScreen()) ? const PosSecondaryScreen() : App());
  });
}
