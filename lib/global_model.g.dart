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

PrinterLocalStrongDataModel _$PrinterLocalStrongDataModelFromJson(
        Map<String, dynamic> json) =>
    PrinterLocalStrongDataModel(
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
      paperSize: json['paperSize'] as int? ?? 2,
      printBillAuto: json['printBillAuto'] as bool? ?? false,
    );

Map<String, dynamic> _$PrinterLocalStrongDataModelToJson(
        PrinterLocalStrongDataModel instance) =>
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

PosHoldProcessModel _$PosHoldProcessModelFromJson(Map<String, dynamic> json) =>
    PosHoldProcessModel(
      holdNumber: json['holdNumber'] as int,
    )
      ..logCount = json['logCount'] as int
      ..saleCode = json['saleCode'] as String
      ..saleName = json['saleName'] as String
      ..customerCode = json['customerCode'] as String
      ..customerName = json['customerName'] as String
      ..customerPhone = json['customerPhone'] as String
      ..payScreenData =
          PosPayModel.fromJson(json['payScreenData'] as Map<String, dynamic>)
      ..posProcess =
          PosProcessModel.fromJson(json['posProcess'] as Map<String, dynamic>);

Map<String, dynamic> _$PosHoldProcessModelToJson(
        PosHoldProcessModel instance) =>
    <String, dynamic>{
      'holdNumber': instance.holdNumber,
      'logCount': instance.logCount,
      'saleCode': instance.saleCode,
      'saleName': instance.saleName,
      'customerCode': instance.customerCode,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'payScreenData': instance.payScreenData.toJson(),
      'posProcess': instance.posProcess.toJson(),
    };

HttpGetDataModel _$HttpGetDataModelFromJson(Map<String, dynamic> json) =>
    HttpGetDataModel(
      code: json['code'] as String,
      json: json['json'] as String,
    );

Map<String, dynamic> _$HttpGetDataModelToJson(HttpGetDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'json': instance.json,
    };

HttpParameterModel _$HttpParameterModelFromJson(Map<String, dynamic> json) =>
    HttpParameterModel(
      parentGuid: json['parentGuid'] as String? ?? "",
      guid: json['guid'] as String? ?? "",
      barcode: json['barcode'] as String? ?? "",
      jsonData: json['jsonData'] as String? ?? "",
      holdNumber: json['holdNumber'] as int? ?? 0,
      docMode: json['docMode'] as int? ?? 0,
    );

Map<String, dynamic> _$HttpParameterModelToJson(HttpParameterModel instance) =>
    <String, dynamic>{
      'parentGuid': instance.parentGuid,
      'guid': instance.guid,
      'barcode': instance.barcode,
      'jsonData': instance.jsonData,
      'holdNumber': instance.holdNumber,
      'docMode': instance.docMode,
    };
