import 'package:dedepos/app/app.dart';
import 'package:flutter/material.dart';
// import 'app.dart';
import 'core/core.dart';
import 'flavors.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServiceLocator();

  F.appFlavor = Flavor.VFPOS;
  runApp(App());
}
