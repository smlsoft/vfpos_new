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
  // Test
  global.userLogin = EmployeeObjectBoxStruct(
    code: "001",
    name: "Test",
    email: "",
    guidfixed: "00000000-0000-0000-0000-000000000000",
    is_enabled: true,
    is_use_pos: true,
    pin_code: "12345",
    profile_picture: "",
  );
  F.appFlavor = Flavor.DEDEPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  global.applicationName = "DeDe Pos";
  initializeDateFormatting();
  await initializeApp();
  runApp((isCustomerDisplayScreen()) ? const PosSecondaryScreen() : App());
}
