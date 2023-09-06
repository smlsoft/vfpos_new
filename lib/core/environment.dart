// ignore_for_file: constant_identifier_names

import 'package:dedepos/app/app_constant.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  late BaseConfig config;
  late bool isDev;

  initConfig(String environment) {
    config = _getConfig(environment);
    isDev = environment == DEV;
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      case Environment.STAGING:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}

abstract class BaseConfig {
  String get serviceApi;
  String get serviceLoginApi;
  String get reportApi;
  String get xapikey;
}

class DevConfig extends BaseConfig {
  @override
  String get serviceApi => AppConstant.serviceDevApi;
  String get serviceLoginApi => AppConstant.serviceLoginDevApi;
  String get reportApi => AppConstant.reportDevApi;
  String get xapikey => AppConstant.xapikey;
}

class ProdConfig extends BaseConfig {
  @override
  String get serviceApi => AppConstant.serviceApi;
  String get serviceLoginApi => AppConstant.serviceLoginApi;
  String get reportApi => AppConstant.reportPrdApi;
  String get xapikey => AppConstant.xapikey;
}

class StagingConfig extends BaseConfig {
  @override
  String get serviceApi => AppConstant.serviceApi;
  String get serviceLoginApi => AppConstant.serviceLoginApi;
  String get reportApi => AppConstant.reportPrdApi;
  String get xapikey => AppConstant.xapikey;
}
