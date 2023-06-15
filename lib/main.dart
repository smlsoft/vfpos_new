import 'dart:convert';

import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/google_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/global.dart' as global;
import 'app/app_view.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.VFPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  await setUpServiceLocator();
  await initializeApp();
  runApp(App());
}
