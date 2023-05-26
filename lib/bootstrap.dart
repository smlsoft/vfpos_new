import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dedepos/app/http_verify.dart';
import 'package:dedepos/core/environment.dart';
import 'package:dedepos/core/language.dart';
import 'package:dedepos/core/objectbox.dart';
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
  HttpOverrides.global = new MyHttpOverrides();
  await GetStorage.init('AppStorage');
  await setupObjectBox();
  await initLanguage();
}

void initializeEnvironmentConfig() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  Environment().initConfig(environment);
}
