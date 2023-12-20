import 'package:dedepos/api/sync/model/qr_model.dart';
import 'package:dedepos/global_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qr_flutter/qr_flutter.dart';
part 'posterminal_model.g.dart';

@JsonSerializable()
class PosTerminalModel {
  late String guidfixed;
  late BranchModel branch;

  /// รหัสรเครื่อง
  late String code;

  /// หมายเลขเครื่อง
  late String devicenumber;

  /// รูปแบบเลขที่เอกสารอย่างย่อ
  late String docformatinv;

  /// รูปแบบเลขที่เอกสารอย่างเต็ม
  late String docformattaxinv;

  /// พื้นที่เก็บสินค้า
  late LocationModel location;

  /// รูปแบบใบเสร็จรับเงิน
  late String receiptform;

  /// รหัสคลังสินค้า
  late WarehouseModel warehouse;

  /// รหัสพนักงานที่ใช้งาน
  late String? activepin;

  /// รายชื่อพนักงานที่ใช้งาน
  late List<EmployeePosModel>? employees;

  /// รหัสเอกสาร
  late String? doccode;

  /// รูปแบบเลขที่เอกสารรับคืน
  late String? docformatesalereturn;

  /// ประเภทภาษี
  late int? vattype;

  /// อัตราภาษี
  late double? vatrate;

  /// slips
  late List<SlipModel>? slips;

  /// vatrate
  late bool? isejournal;

  /// qr code
  late List<QrModel>? qrcodes;

  /// bill header
  late List<LanguageDataModel>? billheader;

  /// bill footer
  late List<LanguageDataModel>? billfooter;

  /// logo pos
  late String? logourl;

  /// จดทะเบียนภาษีมูลค่าเพิ่ม
  late bool? isvatregister;

  /// รหัสสื่อโฆษณา
  late String? mediaguid;

  /// value timezone
  late String? timezoneoffset;

  /// name timezone
  late String? timezonelabel;

  /// time for sale alcohol
  late List<TimeForsaleModel> timeforsales;

  /// ขายเงินเชื่อ
  late bool isusecreadit;

  PosTerminalModel({
    required this.guidfixed,
    required this.branch,
    required this.code,
    required this.devicenumber,
    required this.docformatinv,
    required this.docformattaxinv,
    required this.location,
    required this.receiptform,
    required this.warehouse,
    String? activepin,
    List<EmployeePosModel>? employees,
    String? doccode,
    String? docformatesalereturn,
    int? vattype,
    double? vatrate,
    List<SlipModel>? slips,
    bool? isejournal,
    List<QrModel>? qrcodes,
    bool? isvatregister,
    String? mediaguid,
    String? timezoneoffset,
    String? timezonelabel,
    List<TimeForsaleModel>? timeforsales,
    List<LanguageDataModel>? billheader,
    List<LanguageDataModel>? billfooter,
    String? logourl,
    bool? isusecreadit,
  })  : activepin = activepin ?? '',
        employees = employees ?? <EmployeePosModel>[],
        doccode = doccode ?? '',
        docformatesalereturn = docformatesalereturn ?? '',
        vattype = vattype ?? 0,
        vatrate = vatrate ?? 0.0,
        slips = slips ?? <SlipModel>[],
        isejournal = isejournal ?? false,
        qrcodes = qrcodes ?? <QrModel>[],
        isvatregister = isvatregister ?? true,
        mediaguid = mediaguid ?? '',
        timezoneoffset = timezoneoffset ?? '',
        timezonelabel = timezonelabel ?? '',
        timeforsales = timeforsales ?? <TimeForsaleModel>[],
        billheader = billheader ?? <LanguageDataModel>[],
        billfooter = billfooter ?? <LanguageDataModel>[],
        logourl = logourl ?? '',
        isusecreadit = isusecreadit ?? false;

  factory PosTerminalModel.fromJson(Map<String, dynamic> json) => _$PosTerminalModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosTerminalModelToJson(this);
}

@JsonSerializable()
class BranchModel {
  late String code;
  late String guidfixed;
  late List<LanguageDataModel> names;

  BranchModel({
    required this.code,
    required this.guidfixed,
    required this.names,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}

@JsonSerializable()
class LocationModel {
  late String code;
  late List<LanguageDataModel> names;

  LocationModel({
    required this.code,
    required this.names,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

@JsonSerializable()
class WarehouseModel {
  late String code;
  late String guidfixed;
  late List<LanguageDataModel> names;

  WarehouseModel({
    required this.code,
    required this.guidfixed,
    required this.names,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => _$WarehouseModelFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);
}

@JsonSerializable()
class EmployeePosModel {
  late String code;
  late String guidfixed;
  late String name;
  late List<String> permissions;

  EmployeePosModel({
    required this.code,
    required this.guidfixed,
    required this.name,
    required this.permissions,
  });

  factory EmployeePosModel.fromJson(Map<String, dynamic> json) => _$EmployeePosModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeePosModelToJson(this);
}

/// slips
@JsonSerializable()
class SlipModel {
  late String code;
  late bool isrequire;
  late String name;
  late String formcode;
  late List<LanguageDataModel> formnames = <LanguageDataModel>[];
  late List<LanguageDataModel> headernames = <LanguageDataModel>[];

  SlipModel({
    required this.code,
    required this.isrequire,
    required this.name,
    String? formcode,
    List<LanguageDataModel>? formnames,
    List<LanguageDataModel>? headernames,
  })  : formnames = formnames ?? <LanguageDataModel>[],
        formcode = formcode ?? '',
        headernames = headernames ?? <LanguageDataModel>[];

  factory SlipModel.fromJson(Map<String, dynamic> json) => _$SlipModelFromJson(json);
  Map<String, dynamic> toJson() => _$SlipModelToJson(this);
}

/// เวลาขายสุรา
@JsonSerializable()
class TimeForsaleModel {
  late String from;
  late String to;
  late List<LanguageDataModel> names;

  TimeForsaleModel({
    required this.from,
    required this.to,
    required this.names,
  });

  factory TimeForsaleModel.fromJson(Map<String, dynamic> json) => _$TimeForsaleModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeForsaleModelToJson(this);
}
