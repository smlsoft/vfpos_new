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
      printerCashierType: json['printerCashierType'] as int,
      printerCashierConnectType: json['printerCashierConnectType'] as int,
      printerCashierIpAddress: json['printerCashierIpAddress'] as String,
      printerCashierIpPort: json['printerCashierIpPort'] as int,
    );

Map<String, dynamic> _$LocalStrongDataModelToJson(
        LocalStrongDataModel instance) =>
    <String, dynamic>{
      'printerCashierType': instance.printerCashierType,
      'printerCashierConnectType': instance.printerCashierConnectType,
      'printerCashierIpAddress': instance.printerCashierIpAddress,
      'printerCashierIpPort': instance.printerCashierIpPort,
    };
