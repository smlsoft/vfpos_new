import 'package:flutter/material.dart';
import 'package:dedepos/app/app.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/flavors.dart';

void main() {
  F.appFlavor = Flavor.VFPOS;
  setUpServiceLocator();
  runApp(App());
  // bootstrap(() => App());
}
