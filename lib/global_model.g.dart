// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageSystemModel _$LanguageSystemModelFromJson(Map<String, dynamic> json) =>
    LanguageSystemModel(
      code: json['code'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$LanguageSystemModelToJson(
        LanguageSystemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'text': instance.text,
    };

LanguageSystemCodeModel _$LanguageSystemCodeModelFromJson(
        Map<String, dynamic> json) =>
    LanguageSystemCodeModel(
      code: json['code'] as String,
      langs: (json['langs'] as List<dynamic>)
          .map((e) => LanguageSystemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguageSystemCodeModelToJson(
        LanguageSystemCodeModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'langs': instance.langs.map((e) => e.toJson()).toList(),
    };

LocalStrongDataModel _$LocalStrongDataModelFromJson(
        Map<String, dynamic> json) =>
    LocalStrongDataModel(
      printerCashierType: json['printerCashierType'] as int? ?? 0,
      connectType: json['connectType'] as int? ?? 0,
      ipAddress: json['ipAddress'] as String? ?? "",
      ipPort: json['ipPort'] as int? ?? 0,
      productName: json['productName'] as String? ?? "",
      deviceName: json['deviceName'] as String? ?? "",
      deviceId: json['deviceId'] as String? ?? "",
      manufacturer: json['manufacturer'] as String? ?? "",
      vendorId: json['vendorId'] as String? ?? "",
      productId: json['productId'] as String? ?? "",
      paperSize: json['paperSize'] as int? ?? 0,
      printBillAuto: json['printBillAuto'] as bool? ?? false,
    );

Map<String, dynamic> _$LocalStrongDataModelToJson(
        LocalStrongDataModel instance) =>
    <String, dynamic>{
      'printerCashierType': instance.printerCashierType,
      'connectType': instance.connectType,
      'ipAddress': instance.ipAddress,
      'ipPort': instance.ipPort,
      'productName': instance.productName,
      'deviceName': instance.deviceName,
      'deviceId': instance.deviceId,
      'manufacturer': instance.manufacturer,
      'vendorId': instance.vendorId,
      'productId': instance.productId,
      'paperSize': instance.paperSize,
      'printBillAuto': instance.printBillAuto,
    };

ServerDeviceModel _$ServerDeviceModelFromJson(Map<String, dynamic> json) =>
    ServerDeviceModel(
      device: json['device'] as String,
      ip: json['ip'] as String,
      connected: json['connected'] as bool,
    );

Map<String, dynamic> _$ServerDeviceModelToJson(ServerDeviceModel instance) =>
    <String, dynamic>{
      'device': instance.device,
      'ip': instance.ip,
      'connected': instance.connected,
    };
