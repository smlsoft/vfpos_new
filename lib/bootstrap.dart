import 'dart:async';
import 'dart:developer';
import 'package:dedepos/core/environment.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      runApp(await builder());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

Future<void> initializeApp() async {
  await GetStorage.init('AppStorage');
}

void initializeEnvironmentConfig() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  Environment().initConfig(environment);
}
