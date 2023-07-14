import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'app/app_view.dart';
import 'bootstrap.dart';
import 'features/pos/presentation/screens/pos_secondary_screen.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.SMLSUPERPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  await initializeApp();
  runApp((isCustomerDisplayScreen()) ? const PosSecondaryScreen() : App());
}
