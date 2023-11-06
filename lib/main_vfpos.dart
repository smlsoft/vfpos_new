import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_secondary_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/global.dart' as global;
import 'app/app_view.dart';
import 'flavors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  F.appFlavor = Flavor.VFPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";

  global.applicationName = "Village Fund POS";
  await initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp((isCustomerDisplayScreen()) ? const PosSecondaryScreen() : App());
}
