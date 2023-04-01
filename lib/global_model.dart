import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dedepos/global.dart' as global;

part 'global_model.g.dart';

enum payScreenNumberPadWidgetEnum {
  text,
  number,
}

@JsonSerializable(explicitToJson: true)
class LanguageSystemModel {
  String code;
  String text;

  LanguageSystemModel({required this.code, required this.text});

  factory LanguageSystemModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LanguageSystemCodeModel {
  String code;
  List<LanguageSystemModel> langs;

  LanguageSystemCodeModel({required this.code, required this.langs});

  factory LanguageSystemCodeModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemCodeModelToJson(this);
}

class SyncMasterStatusModel {
  late String tableName;
  late String lastUpdate;
}

@JsonSerializable(explicitToJson: true)
class LocalStrongDataModel {
  int printerCashierType;
  int connectType;
  String ipAddress;
  int ipPort;
  String productName;
  String deviceName;
  String deviceId;
  String manufacturer;
  String vendorId;
  String productId;
  // 1 = 58mm, 2 = 80mm
  int paperSize;
  bool printBillAuto;

  LocalStrongDataModel(
      {this.printerCashierType = 0,
      this.connectType = 0,
      this.ipAddress = "",
      this.ipPort = 0,
      this.productName = "",
      this.deviceName = "",
      this.deviceId = "",
      this.manufacturer = "",
      this.vendorId = "",
      this.productId = "",
      this.paperSize = 0,
      this.printBillAuto = false});

  factory LocalStrongDataModel.fromJson(Map<String, dynamic> json) =>
      _$LocalStrongDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocalStrongDataModelToJson(this);
}

class PrinterDeviceModel {
  String productName;
  String deviceName;
  String deviceId;
  String manufacturer;
  String vendorId;
  String productId;
  String ipAddress;
  int ipPort;
  global.PrinterCashierConnectEnum connectType;
  // 1 = 58mm, 2 = 80mm
  int paperSize;

  PrinterDeviceModel(
      {this.productName = "",
      this.deviceName = "",
      this.deviceId = "",
      this.manufacturer = "",
      this.productId = "",
      this.vendorId = "",
      this.ipAddress = "",
      this.ipPort = 0,
      this.paperSize = 0,
      this.connectType = global.PrinterCashierConnectEnum.none});
}

@JsonSerializable()
class ServerDeviceModel {
  late String device;
  late String ip;
  late bool connected;

  ServerDeviceModel(
      {required this.device, required this.ip, required this.connected});

  factory ServerDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$ServerDeviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServerDeviceModelToJson(this);
}

class PosHoldProcessModel {
  int countLog = 0;
  String saleCode = "";
  PosPayModel payScreenData = PosPayModel();
  PosProcessModel posProcess = PosProcessModel();
}

class ThemeStruct {
  late Color background;
  late Color productLevelBackground;
  late Color productBottomBackground;
  late Color productLevelRootBackground;
  late Color productLevelRootBottomBackground;
  late Color transBackground;
  late Color transSelectedBackground;
  late Color transPayBottomBackground;
  late Color transPayBottomDisableBackground;

  // Colors new layout
  late Color secondary;
  late Color orange1;
}
