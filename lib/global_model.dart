import 'package:dedepos/global.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dedepos/global.dart' as global;

part 'global_model.g.dart';

enum PayScreenNumberPadWidgetEnum {
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
class PrinterLocalStrongDataModel {
  String code;
  String name;
  String ipAddress;
  int ipPort;
  String productName;
  String deviceName;
  String deviceId;
  String manufacturer;
  String vendorId;
  String productId;
  int paperType; // 1 = 58mm, 2 = 80mm
  bool printBillAuto;
  PrinterTypeEnum printerType;
  PrinterConnectEnum printerConnectType;
  bool isConfigConnectSuccess;
  bool isReady;
  String formSummeryCode; // ใบสรุปยอดขาย
  String formTaxCode; // ใบกำกับภาษีแบบย่อย
  String formFullTaxCode; // ใบกำกับภาษีแบบเต็ม

  PrinterLocalStrongDataModel(
      {this.code = "",
      this.name = "",
      this.ipAddress = "",
      this.ipPort = 0,
      this.productName = "",
      this.deviceName = "",
      this.deviceId = "",
      this.manufacturer = "",
      this.vendorId = "",
      this.productId = "",
      this.paperType = 2,
      this.isReady = false,
      this.formSummeryCode = "",
      this.formTaxCode = "",
      this.formFullTaxCode = "",
      this.isConfigConnectSuccess = false,
      this.printerType = PrinterTypeEnum.thermal,
      this.printerConnectType = PrinterConnectEnum.ip,
      this.printBillAuto = false});

  factory PrinterLocalStrongDataModel.fromJson(Map<String, dynamic> json) =>
      _$PrinterLocalStrongDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$PrinterLocalStrongDataModelToJson(this);
}

class PrinterDeviceModel {
  String fullName;
  String productName;
  String deviceName;
  String deviceId;
  String manufacturer;
  String vendorId;
  String productId;
  String ipAddress;
  int ipPort;
  global.PrinterConnectEnum connectType;
  global.PrinterTypeEnum printerType;
  // 1 = 58mm, 2 = 80mm
  int paperSize;

  PrinterDeviceModel(
      {this.fullName = "",
      this.productName = "",
      this.deviceName = "",
      this.deviceId = "",
      this.manufacturer = "",
      this.productId = "",
      this.vendorId = "",
      this.ipAddress = "",
      this.ipPort = 0,
      this.paperSize = 0,
      this.printerType = global.PrinterTypeEnum.thermal,
      this.connectType = global.PrinterConnectEnum.ip});
}

@JsonSerializable(explicitToJson: true)
class PosHoldProcessModel {
  /// รหัสการ Hold
  String code;

  /// 1=POS,2=ร้านอาหาร (โต๊ะ)
  int holdType = 1;

  /// จำนวน Log
  int logCount = 0;

  /// รหัส Sale
  String saleCode = "";

  /// ชื่อ Sale
  String saleName = "";

  /// รหัสลูกค้า
  String customerCode = "";

  /// ชื่อลูกค้า
  String customerName = "";

  /// เบอร์โทรลูกค้า
  String customerPhone = "";

  /// การชำระเงิน
  PosPayModel payScreenData = PosPayModel();

  /// รายการสินค้า
  PosProcessModel posProcess = PosProcessModel();

  String tableNumber = "";

  /// เป็นรายการกลับบ้านหรือไม่
  bool isDelivery = false;

  String deliveryNumber = "";

  PosHoldProcessModel({required this.code});

  factory PosHoldProcessModel.fromJson(Map<String, dynamic> json) =>
      _$PosHoldProcessModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosHoldProcessModelToJson(this);
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

@JsonSerializable(explicitToJson: true)
class HttpGetDataModel {
  String code;
  String json;

  HttpGetDataModel({required this.code, required this.json});

  factory HttpGetDataModel.fromJson(Map<String, dynamic> json) =>
      _$HttpGetDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$HttpGetDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HttpParameterModel {
  String parentGuid;
  String guid;
  String barcode;
  String jsonData;
  String holdCode;
  int docMode;

  HttpParameterModel(
      {this.parentGuid = "",
      this.guid = "",
      this.barcode = "",
      this.jsonData = "",
      this.holdCode = "",
      this.docMode = 0});

  factory HttpParameterModel.fromJson(Map<String, dynamic> json) =>
      _$HttpParameterModelFromJson(json);
  Map<String, dynamic> toJson() => _$HttpParameterModelToJson(this);
}

class HttpPost {
  late String command;
  late String data;

  HttpPost({required this.command, this.data = ""});

  Map toJson() => {
        'command': command,
        'data': data,
      };

  factory HttpPost.fromJson(Map<String, dynamic> json) {
    return HttpPost(
      command: json['command'],
      data: json['data'],
    );
  }
}

class PosProcessResultModel {
  String lineGuid;
  int lastCommandCode;

  PosProcessResultModel({this.lineGuid = "", this.lastCommandCode = 0});
}

class InformationModel {
  // 0=Image,1=Video
  int mode = 0;
  String sourceUrl = "";
  int delaySecond = 10;

  InformationModel(
      {required this.mode, required delaySecond, required this.sourceUrl});
}

class PosSaleChannelModel {
  String code;
  String name;
  String logoUrl;

  PosSaleChannelModel(
      {required this.code, required this.name, this.logoUrl = ""});
}

class LanguageModel {
  String code;
  String codeTranslator;
  String name;
  bool use;

  LanguageModel(
      {required this.code,
      required this.codeTranslator,
      required this.name,
      required this.use});
}

@JsonSerializable(explicitToJson: true)
class LanguageDataModel {
  String code;
  String name;

  LanguageDataModel({required this.code, required this.name});

  factory LanguageDataModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageDataModelToJson(this);
}

/* @JsonSerializable(explicitToJson: true)
class LanguageSystemModel {
  String code;
  String text;

  LanguageSystemModel({required this.code, required this.text});

  factory LanguageSystemModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemModelToJson(this);
}
*/

@JsonSerializable()
class ResponseDataModel {
  final List<dynamic> data;

  ResponseDataModel({
    required this.data,
  });

  factory ResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseDataModelToJson(this);
}

class OrderTempDataModel {
  final String orderGuid;
  final String barcode;
  final double qty;
  final String optionSelected;
  final String remark;

  OrderTempDataModel({
    required this.orderGuid,
    required this.barcode,
    required this.qty,
    required this.remark,
    required this.optionSelected,
  });
}

@JsonSerializable(explicitToJson: true)
class OrderProductOptionModel {
  final String guid;
  final int choicetype;
  final int maxselect;
  final int minselect;
  final List<OrderProductLanguageNameModel> names;
  final List<OrderProductOptionChoiceModel> choices;

  OrderProductOptionModel({
    required this.guid,
    required this.choicetype,
    required this.maxselect,
    required this.minselect,
    required this.names,
    required this.choices,
  });

  factory OrderProductOptionModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductOptionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OrderProductOptionChoiceModel {
  final String guid;
  final List<OrderProductLanguageNameModel> names;
  final String price;
  final double qty;
  final bool selected;
  final double priceValue;

  OrderProductOptionChoiceModel({
    required this.guid,
    required this.names,
    required this.price,
    required this.qty,
    required this.selected,
    required this.priceValue,
  });

  factory OrderProductOptionChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductOptionChoiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductOptionChoiceModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OrderProductLanguageNameModel {
  final String code;
  final String name;

  OrderProductLanguageNameModel({
    required this.code,
    required this.name,
  });

  factory OrderProductLanguageNameModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductLanguageNameModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductLanguageNameModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PriceDataModel {
  int keynumber;
  double price;

  PriceDataModel({required this.keynumber, required this.price});

  factory PriceDataModel.fromJson(Map<String, dynamic> json) =>
      _$PriceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileSettingModel {
  ProfileSettingCompanyModel company;
  List<String> languagelist;
  ProfileSettingConfigSystemModel configsystem;
  List<ProfileSettingBranchModel> branch;

  ProfileSettingModel(
      {required this.company,
      required this.languagelist,
      required this.configsystem,
      required this.branch});

  factory ProfileSettingModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileSettingModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileSettingBranchModel {
  String code;
  List<LanguageDataModel> names;

  ProfileSettingBranchModel({
    required this.code,
    required this.names,
  });

  factory ProfileSettingBranchModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingBranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileSettingBranchModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileSettingConfigSystemModel {
  double vatrate;
  int vattypesale;
  int vattypepurchase;
  int inquirytypesale;
  int inquirytypepurchase;
  String headerreceiptpos;
  String footerreciptpos;

  ProfileSettingConfigSystemModel(
      {required this.vatrate,
      required this.vattypesale,
      required this.vattypepurchase,
      required this.inquirytypesale,
      required this.inquirytypepurchase,
      required this.headerreceiptpos,
      required this.footerreciptpos});

  factory ProfileSettingConfigSystemModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingConfigSystemModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ProfileSettingConfigSystemModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileSettingCompanyModel {
  List<LanguageDataModel> names;
  String taxID;
  List<LanguageDataModel> branchNames;
  List<LanguageDataModel> addresses;
  List<String> phones;
  List<String> emailOwners;
  List<String> emailStaffs;
  String latitude;
  String longitude;
  bool usebranch;
  bool usedepartment;
  List<String> images;
  String logo;

  ProfileSettingCompanyModel(
      {required this.names,
      required this.taxID,
      required this.branchNames,
      required this.addresses,
      required this.phones,
      required this.emailOwners,
      required this.emailStaffs,
      required this.latitude,
      required this.longitude,
      required this.usebranch,
      required this.usedepartment,
      required this.images,
      required this.logo});

  factory ProfileSettingCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileSettingCompanyModelToJson(this);
}
