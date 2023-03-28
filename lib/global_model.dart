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
  int printerCashierConnectType;
  String printerCashierIpAddress;
  int printerCashierIpPort;

  LocalStrongDataModel(
      {required this.printerCashierType,
      required this.printerCashierConnectType,
      required this.printerCashierIpAddress,
      required this.printerCashierIpPort});

  factory LocalStrongDataModel.fromJson(Map<String, dynamic> json) =>
      _$LocalStrongDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocalStrongDataModelToJson(this);
}

class PrinterModel {
  String name;
  String ipAddress;
  int ipPort;
  global.PrinterCashierConnectEnum connectType;

  PrinterModel(
      {required this.name,
      required this.ipAddress,
      required this.ipPort,
      required this.connectType});
}
